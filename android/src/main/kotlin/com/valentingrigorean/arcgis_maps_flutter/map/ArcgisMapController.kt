package com.valentingrigorean.arcgis_maps_flutter.map

import android.content.Context
import android.graphics.SurfaceTexture
import android.util.Log
import android.view.TextureView
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.lifecycle.Lifecycle
import com.arcgismaps.LoadStatus
import com.arcgismaps.arcgisservices.TimeAware
import com.arcgismaps.geometry.Envelope
import com.arcgismaps.geometry.GeometryEngine
import com.arcgismaps.mapping.ArcGISMap
import com.arcgismaps.mapping.Basemap
import com.arcgismaps.mapping.MobileMapPackage
import com.arcgismaps.mapping.Viewpoint
import com.arcgismaps.mapping.ViewpointType
import com.arcgismaps.mapping.layers.ArcGISVectorTiledLayer
import com.arcgismaps.mapping.view.GraphicsOverlay
import com.arcgismaps.mapping.view.MapView
import com.valentingrigorean.arcgis_maps_flutter.convert.arcgisservices.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toGeometryOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toPointOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.mapping.toArcGISMapOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.mapping.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.convert.mapping.toTimeExtentOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.mapping.toViewpointOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.mapping.toViewpointType
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterValue
import com.valentingrigorean.arcgis_maps_flutter.extensions.loadAll
import com.valentingrigorean.arcgis_maps_flutter.layers.LayersController
import com.valentingrigorean.arcgis_maps_flutter.layers.LegendInfoController
import com.valentingrigorean.arcgis_maps_flutter.map.LocationDisplayController.LocationDisplayControllerDelegate
import com.valentingrigorean.arcgis_maps_flutter.mapping.symbology.MarkersController
import com.valentingrigorean.arcgis_maps_flutter.mapping.symbology.PolygonsController
import com.valentingrigorean.arcgis_maps_flutter.mapping.symbology.PolylinesController
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.platform.PlatformView
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.cancel
import kotlinx.coroutines.ensureActive
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.launch


class ArcgisMapController(
    id: Int,
    private val context: Context,
    params: Map<String, Any>?,
    binaryMessenger: BinaryMessenger,
    lifecycleProvider: () -> Lifecycle
) : PlatformView, MethodCallHandler, LocationDisplayControllerDelegate {

    companion object {
        private const val TAG = "ArcgisMapController"
    }

    private val methodChannel: MethodChannel
    private val selectionPropertiesHandler: SelectionPropertiesHandler
    private val layersController: LayersController
    private val markersController: MarkersController
    private val polygonsController: PolygonsController
    private val polylinesController: PolylinesController
    private val symbolControllers = ArrayList<SymbolsController>()
    private val mapChangeAwares = ArrayList<MapChangeAware>()
    private val symbolVisibilityFilterController: SymbolVisibilityFilterController
    private val locationDisplayController: LocationDisplayController
    private val container: FrameLayout = FrameLayout(context)
    private var mapView: MapView
    private var mapViewOnTouchListener: MapViewOnTouchListener
    private var scaleBarController: ScaleBarController
    private var viewpoint: Viewpoint? = null
    private var haveScaleBar = false
    private var trackViewpointChangedListenerEvents = false
    private var trackTimeExtentEvents = false
    private var disposed = false
    private var minScale = 0.0
    private var maxScale = 0.0
    private val scope: CoroutineScope = CoroutineScope(Dispatchers.Main)

    private val lifecycle = lifecycleProvider()


    private var mapJob: Job? = null

    init {
        methodChannel = MethodChannel(binaryMessenger, "plugins.flutter.io/arcgis_maps_$id")
        methodChannel.setMethodCallHandler(this)
        mapView = MapView(context)
        container.addView(
            mapView,
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT
        )
        lifecycle.addObserver(mapView)
        scaleBarController = ScaleBarController(context, mapView, container, scope)
        selectionPropertiesHandler = SelectionPropertiesHandler(mapView.selectionProperties)
        symbolVisibilityFilterController = SymbolVisibilityFilterController(mapView, scope)
        layersController = LayersController(methodChannel, scope)
        mapChangeAwares.add(layersController)
        val graphicsOverlay = GraphicsOverlay()
        markersController = MarkersController(context, methodChannel, graphicsOverlay)
        symbolControllers.add(markersController)
        polygonsController = PolygonsController(methodChannel, graphicsOverlay)
        symbolControllers.add(polygonsController)
        polylinesController = PolylinesController(methodChannel, graphicsOverlay)
        symbolControllers.add(polylinesController)
        val locationDisplayChannel = MethodChannel(
            binaryMessenger, "plugins.flutter.io/arcgis_maps_" + id + "_location_display"
        )
        locationDisplayController = LocationDisplayController(
            locationDisplayChannel, mapView.locationDisplay, mapView, scope
        )
        locationDisplayController.setLocationDisplayControllerDelegate(this)
        initSymbolsControllers()
        mapViewOnTouchListener = MapViewOnTouchListener(mapView, methodChannel, scope)
        mapViewOnTouchListener.addGraphicDelegate(markersController)
        mapViewOnTouchListener.addGraphicDelegate(polygonsController)
        mapViewOnTouchListener.addGraphicDelegate(polylinesController)
        mapViewOnTouchListener.addGraphicDelegate(locationDisplayController)
        mapView.graphicsOverlays.add(graphicsOverlay)
        mapView.viewpointChanged.onEach {
            if (trackViewpointChangedListenerEvents) {
                methodChannel.invokeMethod("map#viewpointChanged", null)
            }
        }.launchIn(scope)

        mapView.timeExtent.onEach {
            if (trackTimeExtentEvents) {
                methodChannel.invokeMethod("map#timeExtentChanged", it?.toFlutterJson())
            }
        }.launchIn(scope)

        if (params != null) {
            initWithParams(params)
        }

        installInvalidator()
    }

    override fun getView(): View {
        return container
    }

    override fun dispose() {
        if (disposed) {
            return
        }
        scope.cancel()
        disposed = true
        trackTimeExtentEvents = false
        trackViewpointChangedListenerEvents = false
        methodChannel.setMethodCallHandler(null)
        lifecycle.removeObserver(mapView)
        scaleBarController.dispose()
        mapViewOnTouchListener.clearAllDelegates()
        symbolVisibilityFilterController.clear()
        clearSymbolsControllers()
        clearMapAwareControllers()
        locationDisplayController.setLocationDisplayControllerDelegate(null)
        locationDisplayController.dispose()
        destroyMapViewIfNecessary()
    }

    override fun onUserLocationTap() {
        methodChannel.invokeMethod("map#onUserLocationTap", null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (disposed) {
            result.success(null)
            return
        }
        when (call.method) {
            "map#waitForMap" -> {
                result.success(null)
            }

            "map#update" -> {
                val data = call.argument<Map<*, *>>("options")
                data?.let { updateMapOptions(it) }
                result.success(null)
            }

            "map#exportImage" -> {
                scope.launch {
                    mapView.exportImage().onSuccess {
                        result.success(it.toFlutterValue())
                    }.onFailure {
                        result.error("exportImage", it.message, null)
                    }
                }
            }

            "map#getLegendInfos" -> {
                scope.launch {
                    val legendInfoController = LegendInfoController(context, layersController)
                    legendInfoController.load(call.arguments as Map<*, *>).onSuccess {
                        result.success(it)
                    }.onFailure {
                        result.error("getLegendInfos", it.message, null)
                    }
                }
            }

            "map#getMapMaxExtend" -> {
                scope.launch {
                    val map = mapView.map
                    if (map == null) {
                        result.success(null)
                        return@launch
                    }
                    map.load().onSuccess {
                        result.success(map.maxExtent?.toFlutterJson())
                    }.onFailure {
                        result.error("getMapMaxExtend", it.message, null)
                    }
                }
            }

            "map#setMapMaxExtent" -> {
                val maxExtend = call.arguments.toGeometryOrNull() as Envelope?
                mapView.map?.maxExtent = maxExtend
                result.success(null)
            }

            "map#setMap" -> {
                changeMapType(call.arguments)
                result.success(null)
            }

            "map#setTimeExtentChangedListener" -> {
                val track = call.arguments<Boolean>()!!
                if (trackTimeExtentEvents != track) {
                    trackTimeExtentEvents = track

                }
                result.success(null)
            }

            "map#setViewpointChangedListenerEvents" -> {
                trackViewpointChangedListenerEvents = call.arguments()!!
                result.success(null)
            }

            "map#getTimeExtent" -> {
                result.success(mapView.timeExtent.value?.toFlutterJson())
            }

            "map#setTimeExtent" -> {
                mapView.setTimeExtent(call.arguments.toTimeExtentOrNull())
                result.success(null)
            }

            "map#getMapRotation" -> {
                result.success(mapView.mapRotation.value)
            }

            "map#getWanderExtentFactor" -> {
                result.success(mapView.locationDisplay.wanderExtentFactor)
            }

            "map#queryFeatureTableFromLayer" -> {
                handleQueryFeatureTableFromLayer(call.arguments as Map<*, *>, result)
            }

            "map#getTimeAwareLayerInfos" -> handleTimeAwareLayerInfos(result)
            "map#getCurrentViewpoint" -> {
                val viewpointType = (call.arguments as Int).toViewpointType()
                result.success(mapView.getCurrentViewpoint(viewpointType)?.toFlutterJson())
            }

            "map#setViewpoint" -> {
                setViewpoint(call.arguments, true, result)
            }

            "map#setViewpointGeometry" -> {
                scope.launch {
                    val data = call.arguments<Map<*, *>>()!!
                    val geometry = data["geometry"]?.toGeometryOrNull()!!
                    val padding = data["padding"] as Double? ?: 0.0
                    mapView.setViewpointGeometry(geometry, padding).onSuccess {
                        result.success(true)
                    }.onFailure {
                        result.success(false)
                    }
                }
            }

            "map#setViewpointCenter" -> {
                scope.launch {
                    val data = call.arguments<Map<*, *>>()!!
                    val center = data["center"]?.toPointOrNull()!!
                    val scale = data["scale"] as Double
                    mapView.setViewpointCenter(center, scale).onSuccess {
                        result.success(true)
                    }.onFailure {
                        result.success(false)
                    }
                }
            }

            "map#setViewpointRotation" -> {
                scope.launch {
                    val angleDegrees = call.arguments<Double>()!!
                    mapView.setViewpointRotation(angleDegrees).onSuccess {
                        result.success(true)
                    }.onFailure {
                        result.success(false)
                    }
                }
            }

            "map#locationToScreen" -> {
                val mapPoint = call.arguments.toPointOrNull()!!
                val screenPoint = mapView.locationToScreen(mapPoint)
                result.success(listOf(screenPoint.x, screenPoint.y))
            }

            "map#screenToLocation" -> {
                val screenLocationData = ScreenLocationData.fromJson(call.arguments as Map<*, *>)
                val mapPoint = mapView.screenToLocation(screenLocationData.point)?.let {
                    if (screenLocationData.spatialReference != null && it.spatialReference?.wkid != screenLocationData.spatialReference?.wkid) {
                        GeometryEngine.projectOrNull(it, screenLocationData.spatialReference)
                    } else {
                        it
                    }
                }
                result.success(mapPoint?.toFlutterJson())
            }

            "map#getMapSpatialReference" -> {
                val map = mapView.map
                if (map == null) {
                    result.success(null)
                    return
                }
                result.success(map.spatialReference?.toFlutterJson())
            }

            "map#getMapScale" -> {
                result.success(mapView.mapScale.value)
            }

            "layers#update" -> {
                layersController.updateFromArgs(call.arguments)
                result.success(null)
            }

            "markers#update" -> {
                val markersToAdd = call.argument<List<Any>>("markersToAdd")!!
                markersController.addMarkers(markersToAdd)
                val markersToChange = call.argument<List<Any>>("markersToChange")!!
                markersController.changeMarkers(markersToChange)
                val markerIdsToRemove = call.argument<List<Any>>("markerIdsToRemove")!!
                markersController.removeMarkers(markerIdsToRemove)
                symbolVisibilityFilterController.invalidate()
                result.success(null)
            }

            "map#clearMarkerSelection" -> {
                selectionPropertiesHandler.reset()
                markersController.clearSelectedMarker()
                result.success(null)
            }

            "polygons#update" -> {
                val polygonsToAdd = call.argument<List<Any>>("polygonsToAdd")!!
                polygonsController.addPolygons(polygonsToAdd)
                val polygonsToChange = call.argument<List<Any>>("polygonsToChange")!!
                polygonsController.changePolygons(polygonsToChange)
                val polygonIdsToRemove = call.argument<List<Any>>("polygonIdsToRemove")!!
                polygonsController.removePolygons(polygonIdsToRemove)
                result.success(null)
            }

            "polylines#update" -> {
                val polylinesToAdd = call.argument<List<Any>>("polylinesToAdd")!!
                polylinesController.addPolylines(polylinesToAdd)
                val polylinesToChange = call.argument<List<Any>>("polylinesToChange")!!
                polylinesController.changePolylines(polylinesToChange)
                val polylineIdsToRemove = call.argument<List<Any>>("polylineIdsToRemove")!!
                polylinesController.removePolylines(polylineIdsToRemove)
                result.success(null)
            }

            "layer#setTimeOffset" -> {
                layersController.setTimeOffset(call.arguments)
                result.success(null)
            }

            "map#setViewpointScaleAsync" -> {
                scope.launch {
                    val data = call.arguments<Map<*, *>>()!!
                    val scale = data["scale"] as Double
                    mapView.setViewpointScale(scale).onSuccess {
                        result.success(true)
                    }.onFailure {
                        result.success(false)
                    }
                }
            }

            "map#getInitialViewpoint" -> {
                result.success(mapView.map?.initialViewpoint?.toFlutterJson())
            }

            else -> result.notImplemented()
        }
    }

    private fun destroyMapViewIfNecessary() {
        container.removeView(mapView)
    }

    private fun findTextureView(group: ViewGroup): TextureView? {
        for (i in 0 until group.childCount) {
            val child = group.getChildAt(i)
            if (child is TextureView) {
                return child
            } else if (child is ViewGroup) {
                val textureView = findTextureView(child)
                if (textureView != null) {
                    return textureView
                }
            }
        }
        return null
    }

    private fun installInvalidator() {
        val textureView = findTextureView(mapView) ?: return
        Log.i(TAG, "Installing custom TextureView driven invalidator.")
        val internalListener = textureView.surfaceTextureListener
        textureView.surfaceTextureListener = object : TextureView.SurfaceTextureListener {
            override fun onSurfaceTextureAvailable(
                surface: SurfaceTexture,
                width: Int,
                height: Int
            ) {
                internalListener?.onSurfaceTextureAvailable(surface, width, height)
            }

            override fun onSurfaceTextureDestroyed(surface: SurfaceTexture): Boolean {
                return internalListener?.onSurfaceTextureDestroyed(surface) ?: true
            }

            override fun onSurfaceTextureSizeChanged(
                surface: SurfaceTexture,
                width: Int,
                height: Int
            ) {
                internalListener?.onSurfaceTextureSizeChanged(surface, width, height)
            }

            override fun onSurfaceTextureUpdated(surface: SurfaceTexture) {
                internalListener?.onSurfaceTextureUpdated(surface)
                mapView.invalidate()
            }
        }
    }

    private fun handleQueryFeatureTableFromLayer(data: Map<*, *>, result: MethodChannel.Result) {
        result.notImplemented()

//        val params = QueryParameters()
//        var layerName: String? = ""
//
//        // init query params
//        for ((key, value) in data) {
//            when (key) {
//                "layerName" -> layerName = value as String?
//                "objectId" -> params.objectIds.add(value as kotlin.String?). toLong ())
//                "maxResults" -> params.maxFeatures = value as kotlin.String?. toInt ()
//                "geometry" -> params.geometry =  value?.toGeometryOrNull()
//
//                "spatialRelationship" -> params.spatialRelationship =
//                    (value as Int).toSpatialRelationship()
//
//                else -> if (params.whereClause.isEmpty()) {
//                    params.whereClause = String.format(
//                        "upper(%s) LIKE '%%%s%%'",
//                        key,
//                        value.toString().uppercase(Locale.getDefault())
//                    )
//                } else {
//                    val whereClause = params.whereClause
//                    params.whereClause = whereClause + String.format(
//                        " AND upper(%s) LIKE '%%%s%%'",
//                        key,
//                        value.toString().uppercase(Locale.getDefault())
//                    )
//                }
//            }
//        }
//
//        // check map
//        val map = mapView.map
//        if (map == null || map.operationalLayers.size == 0) {
//            result.success(null)
//            return
//        }
//        val layers = map.operationalLayers
//        val finalLayerName = layerName
//        AGSLoadObjects.load(layers, LoadObjectsResult { loaded: Boolean ->
//            if (!loaded) {
//                result.success(null)
//                return@LoadObjectsResult
//            }
//            for (layer in layers) {
//                if (layer is FeatureLayer) {
//                    val featureLayer = layer as FeatureLayer
//                    if (featureLayer.name.equals(finalLayerName, ignoreCase = true)) {
//                        val future =
//                            featureLayer.featureTable.queryFeaturesAsync(params)
//                        future.addDoneListener {
//                            try {
//                                val queryResult = future.get()
//                                val results = ArrayList<Any>()
//                                for (feature in queryResult) {
//                                    results.add(feature.toMap())
//                                }
//                                result.success(results)
//                            } catch (e: Exception) {
//                                result.success(null)
//                            }
//                        }
//                        return@LoadObjectsResult
//                    }
//                } else if (layer is GroupLayer) {
//                    val gLayer = layer as GroupLayer
//                    for (layerItem in gLayer.layers) {
//                        if (layerItem is FeatureLayer) {
//                            val featureLayer = layerItem
//                            if (featureLayer.name.equals(
//                                    finalLayerName,
//                                    ignoreCase = true
//                                )
//                            ) {
//                                val future =
//                                    featureLayer.featureTable.queryFeaturesAsync(params)
//                                future.addDoneListener {
//                                    try {
//                                        val queryResult = future.get()
//                                        val results = ArrayList<Any>()
//                                        for (feature in queryResult) {
//                                            results.add(feature.toMap())
//                                        }
//                                        result.success(results)
//                                    } catch (e: Exception) {
//                                        result.success(null)
//                                    }
//                                }
//                                return@LoadObjectsResult
//                            }
//                        }
//                    }
//                }
//            }
//            result.success(null)
//        })

    }

    private fun handleTimeAwareLayerInfos(result: MethodChannel.Result) {
        val map = mapView.map
        if (map == null || map.operationalLayers.size == 0) {
            result.success(ArrayList<Any>())
            return
        }
        scope.launch {
            map.operationalLayers.loadAll()
            val results =
                map.operationalLayers.takeWhile { it is TimeAware && it.loadStatus.value == LoadStatus.Loaded }
                    .map {
                        val timeAware = it as TimeAware
                        timeAware.toFlutterJson(layersController.getLayerIdByLayer(it))
                    }
            result.success(results)
        }
    }

    private fun initSymbolsControllers() {
        for (controller in symbolControllers) {
            controller.symbolVisibilityFilterController = symbolVisibilityFilterController
            controller.selectionPropertiesHandler = selectionPropertiesHandler
        }
    }

    private fun clearSymbolsControllers() {
        for (controller in symbolControllers) {
            controller.symbolVisibilityFilterController = null
            controller.selectionPropertiesHandler = null
        }
    }

    private fun clearMapAwareControllers() {
        for (mapChangeAware in mapChangeAwares) {
            mapChangeAware.onMapChange(null)
        }
    }

    private fun setViewpoint(args: Any?, animated: Boolean, result: MethodChannel.Result?) {
        scope.launch {
            val currentViewpoint = args?.toViewpointOrNull()
            val map = mapView.map
            if (map == null || currentViewpoint == null) {
                viewpoint = currentViewpoint
                result?.success(null)
                return@launch
            }
            if (animated) {
                mapView.setViewpoint(currentViewpoint)
            } else {
                mapView.setViewpointAnimated(currentViewpoint)
            }
            viewpoint = null
            result?.success(null)
        }
    }

    private fun changeMapType(args: Any?) {
        val data = args as Map<*, *>? ?: return
        mapJob?.cancel()
        if (data.containsKey("offlineInfo")) {
            loadOfflineMap(data["offlineInfo"] as Map<*, *>)
            return
        }
        val map = data.toArcGISMapOrNull()!!
        changeMap(map)
    }

    private fun loadOfflineMap(data: Map<*, *>) {
        val offlinePath = data["path"] as String?
        val mapIndex = data["index"] as Int
        val parts = offlinePath?.split(".")?.filter { it.isNotEmpty() }

        when (parts?.lastOrNull()) {
            "vtpk" -> {
                val baseLayer = ArcGISVectorTiledLayer(offlinePath)
                val baseMap = Basemap(baseLayer)
                changeMap(ArcGISMap(baseMap))
            }

            else -> {
                mapJob = scope.launch {
                    val mobileMapPackage = MobileMapPackage(offlinePath!!)
                    mobileMapPackage.load().onSuccess {
                        val map = mobileMapPackage.maps[mapIndex]
                        ensureActive()
                        changeMap(map)
                    }.onFailure {
                        ensureActive()
                        methodChannel.invokeMethod(
                            "map#loaded", it.toFlutterJson(withStackTrace = false)
                        )
                    }
                }
            }
        }
    }

    private fun changeMap(map: ArcGISMap) {
        mapJob = scope.launch {
            var currentViewpoint = viewpoint
            if (currentViewpoint == null) {
                currentViewpoint = mapView.getCurrentViewpoint(ViewpointType.CenterAndScale)
            }
            map.load().onSuccess {
                ensureActive()
                methodChannel.invokeMethod("map#loaded", null)
            }.onFailure {
                ensureActive()
                methodChannel.invokeMethod(
                    "map#loaded", it.toFlutterJson(withStackTrace = false)
                )
            }
            ensureActive()
            mapView.map = map
            updateMapScale()
            for (mapChangeAware in mapChangeAwares) {
                mapChangeAware.onMapChange(map)
            }
            if (currentViewpoint != null) {
                viewpoint = null
                mapView.setViewpoint(currentViewpoint)
            }
        }
    }

    private fun updateMapOptions(args: Any?) {
        if (args == null) {
            return
        }
        val data = args as Map<*, *>
        val mapOptions = data["interactionOptions"] as Map<*, *>?
        if (mapOptions != null) {
            interpretInteractionOptions(mapOptions)
        }
        val trackUserLocationTap = data["trackUserLocationTap"] as Boolean?
        if (trackUserLocationTap != null) {
            locationDisplayController.setTrackUserLocationTap(
                trackUserLocationTap
            )
        }
        val myLocationEnabled = data["myLocationEnabled"] as? Boolean
        if (myLocationEnabled != null) {
            mapView.locationDisplay.showLocation = myLocationEnabled
        }
        val trackIdentifyLayers = data["trackIdentifyLayers"] as Boolean?
        if (trackIdentifyLayers != null) {
            mapViewOnTouchListener.trackIdentityLayers = trackIdentifyLayers
        }

        val trackIdentifyGraphics = data["trackIdentifyGraphics"] as Boolean?
        if (trackIdentifyGraphics != null) {
            mapViewOnTouchListener.trackIdentifyGraphics = trackIdentifyGraphics
        }
        val haveScaleBar = data["haveScalebar"] as Boolean?
        if (haveScaleBar != null) {
            this.haveScaleBar = haveScaleBar
        }
        val isAttributionTextVisible = data["isAttributionTextVisible"] as Boolean?
        if (isAttributionTextVisible != null && mapView != null) {
            mapView.isAttributionBarVisible = isAttributionTextVisible
        }
        val contentInsets = data["contentInsets"] as List<Double>?
        if (contentInsets != null && mapView != null) {
            // order is left,top,right,bottom
            mapView.setViewInsets(
                contentInsets[0], contentInsets[1], contentInsets[2], contentInsets[3]
            )
        }
        val scaleBarConfiguration = data["scalebarConfiguration"]
        if (scaleBarConfiguration != null) {
            scaleBarController.interpretConfiguration(scaleBarConfiguration)
        } else if (!this.haveScaleBar) {
            scaleBarController.removeScaleBar()
        }
        val minScale = data["minScale"] as Double?
        if (minScale != null) {
            this.minScale = minScale
        }
        val maxScale = data["maxScale"] as Double?
        if (maxScale != null) {
            this.maxScale = maxScale
        }
        updateMapScale()
    }

    private fun initWithParams(params: Map<String, Any>) {
        val viewPoint = params["viewpoint"]
        if (viewPoint != null) {
            viewpoint = viewPoint.toViewpointOrNull()
        }
        val mapType = params["map"]
        mapType?.let { changeMapType(it) }
        val options = params["options"]
        options?.let { updateMapOptions(it) }
        layersController.updateFromArgs(params)
        val markersToAdd = params["markersToAdd"]
        if (markersToAdd != null) {
            markersController.addMarkers(markersToAdd as List<Any>?)
        }
        val polygonsToAdd = params["polygonsToAdd"]
        if (polygonsToAdd != null) {
            polygonsController.addPolygons(polygonsToAdd as List<Any>?)
        }
        val polylinesToAdd = params["polylinesToAdd"]
        if (polylinesToAdd != null) {
            polylinesController.addPolylines(polylinesToAdd as List<Any>)
        }
    }

    private fun updateMapScale() {
        mapView.map?.let {
            it.minScale = minScale
            it.maxScale = maxScale
        }
    }

    private fun interpretInteractionOptions(
        data: Map<*, *>,
    ) {
        val interactionOptions = mapView.interactionOptions
        val isEnabled = data["isEnabled"] as Boolean?
        if (isEnabled != null) {
            interactionOptions.isEnabled = isEnabled
        }
        val isRotateEnabled = data["isRotateEnabled"] as Boolean?
        if (isRotateEnabled != null) {
            interactionOptions.isRotateEnabled = isRotateEnabled
        }
        val isPanEnabled = data["isPanEnabled"] as Boolean?
        if (isPanEnabled != null) {
            interactionOptions.isPanEnabled = isPanEnabled
        }
        val isZoomEnabled = data["isZoomEnabled"] as Boolean?
        if (isZoomEnabled != null) {
            interactionOptions.isZoomEnabled = isZoomEnabled
        }
        val isMagnifierEnabled = data["isMagnifierEnabled"] as Boolean?
        if (isMagnifierEnabled != null) {
            interactionOptions.isMagnifierEnabled = isMagnifierEnabled
        }
        val allowMagnifierToPan = data["allowMagnifierToPan"] as Boolean?
        if (allowMagnifierToPan != null) {
            interactionOptions.allowMagnifierToPan = allowMagnifierToPan
        }
    }
}