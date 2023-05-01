package com.valentingrigorean.arcgis_maps_flutter.map

import android.content.Context
import android.util.Log
import android.view.View
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import com.esri.arcgisruntime.ArcGISRuntimeEnvironment
import com.esri.arcgisruntime.arcgisservices.TimeAware
import com.esri.arcgisruntime.concurrent.ListenableFuture
import com.esri.arcgisruntime.data.QueryParameters
import com.esri.arcgisruntime.geometry.Envelope
import com.esri.arcgisruntime.geometry.Geometry
import com.esri.arcgisruntime.geometry.GeometryEngine
import com.esri.arcgisruntime.geometry.Point
import com.esri.arcgisruntime.layers.ArcGISVectorTiledLayer
import com.esri.arcgisruntime.layers.FeatureLayer
import com.esri.arcgisruntime.layers.GroupLayer
import com.esri.arcgisruntime.loadable.LoadStatus
import com.esri.arcgisruntime.mapping.ArcGISMap
import com.esri.arcgisruntime.mapping.Basemap
import com.esri.arcgisruntime.mapping.MobileMapPackage
import com.esri.arcgisruntime.mapping.Viewpoint
import com.esri.arcgisruntime.mapping.view.GraphicsOverlay
import com.esri.arcgisruntime.mapping.view.TimeExtentChangedEvent
import com.esri.arcgisruntime.mapping.view.TimeExtentChangedListener
import com.esri.arcgisruntime.mapping.view.ViewpointChangedEvent
import com.esri.arcgisruntime.mapping.view.ViewpointChangedListener
import com.valentingrigorean.arcgis_maps_flutter.Convert
import com.valentingrigorean.arcgis_maps_flutter.layers.LayersChangedController
import com.valentingrigorean.arcgis_maps_flutter.layers.LayersController
import com.valentingrigorean.arcgis_maps_flutter.layers.LegendInfoController
import com.valentingrigorean.arcgis_maps_flutter.layers.MapChangeAware
import com.valentingrigorean.arcgis_maps_flutter.map.LocationDisplayController.LocationDisplayControllerDelegate
import com.valentingrigorean.arcgis_maps_flutter.utils.AGSLoadObjects
import com.valentingrigorean.arcgis_maps_flutter.utils.AGSLoadObjects.LoadObjectsResult
import com.valentingrigorean.arcgis_maps_flutter.utils.toMap
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.platform.PlatformView
import java.util.Locale
import java.util.concurrent.ExecutionException

class ArcgisMapController(
    id: Int,
    private val context: Context,
    params: Map<String, Any>?,
    binaryMessenger: BinaryMessenger?,
    private val lifecycleProvider: () -> Lifecycle
) : DefaultLifecycleObserver, PlatformView, MethodCallHandler, ViewpointChangedListener,
    TimeExtentChangedListener, LocationDisplayControllerDelegate {
    private val methodChannel: MethodChannel
    private val selectionPropertiesHandler: SelectionPropertiesHandler
    private val layersController: LayersController
    private val markersController: MarkersController
    private val polygonsController: PolygonsController
    private val polylinesController: PolylinesController
    private val symbolControllers = ArrayList<SymbolsController>()
    private val legendInfoControllers = ArrayList<LegendInfoController>()
    private val mapChangeAwares = ArrayList<MapChangeAware>()
    private val symbolVisibilityFilterController: SymbolVisibilityFilterController
    private val layersChangedController: LayersChangedController
    private val locationDisplayController: LocationDisplayController
    private val mapLoadedListener = MapLoadedListener()
    private var mapView: FlutterMapView?
    private var mapViewOnTouchListener: MapViewOnTouchListener?
    private var scaleBarController: ScaleBarController?
    private val invalidateMapHelper: InvalidateMapHelper
    private var viewpoint: Viewpoint? = null
    private var haveScaleBar = false
    private var trackViewpointChangedListenerEvents = false
    private var trackTimeExtentEvents = false
    private var disposed = false
    private var minScale = 0.0
    private var maxScale = 0.0

    init {
        methodChannel = MethodChannel(binaryMessenger!!, "plugins.flutter.io/arcgis_maps_$id")
        methodChannel.setMethodCallHandler(this)
        mapView = FlutterMapView(context)
        scaleBarController = ScaleBarController(context, mapView!!, mapView!!)
        selectionPropertiesHandler = SelectionPropertiesHandler(mapView.getSelectionProperties())
        symbolVisibilityFilterController = SymbolVisibilityFilterController(mapView!!)
        layersController = LayersController(methodChannel)
        mapChangeAwares.add(layersController)
        layersChangedController = LayersChangedController(methodChannel)
        mapChangeAwares.add(layersChangedController)
        val graphicsOverlay = GraphicsOverlay()
        markersController = MarkersController(context, methodChannel, graphicsOverlay)
        symbolControllers.add(markersController)
        polygonsController = PolygonsController(methodChannel, graphicsOverlay)
        symbolControllers.add(polygonsController)
        polylinesController = PolylinesController(methodChannel, graphicsOverlay)
        symbolControllers.add(polylinesController)
        val locationDisplayChannel = MethodChannel(
            binaryMessenger,
            "plugins.flutter.io/arcgis_maps_" + id + "_location_display"
        )
        locationDisplayController = LocationDisplayController(locationDisplayChannel, mapView!!)
        locationDisplayController.setLocationDisplayControllerDelegate(this)
        initSymbolsControllers()
        mapViewOnTouchListener = MapViewOnTouchListener(context, mapView!!, methodChannel)
        mapViewOnTouchListener!!.addGraphicDelegate(markersController)
        mapViewOnTouchListener!!.addGraphicDelegate(polygonsController)
        mapViewOnTouchListener!!.addGraphicDelegate(polylinesController)
        mapViewOnTouchListener!!.addGraphicDelegate(locationDisplayController)
        mapView.getGraphicsOverlays().add(graphicsOverlay)
        mapView!!.mapView!!.onTouchListener = mapViewOnTouchListener
        mapView!!.addViewpointChangedListener(this)
        invalidateMapHelper = InvalidateMapHelper(mapView!!)
        lifecycleProvider.lifecycle.addObserver(this)
        if (params == null) {
            return
        }
        initWithParams(params)
        Log.d(TAG, "setApiKey: " + ArcGISRuntimeEnvironment.getApiKey())
    }

    override fun getView(): View? {
        return mapView
    }

    override fun dispose() {
        if (disposed) {
            return
        }
        disposed = true
        invalidateMapHelper.dispose()
        trackTimeExtentEvents = false
        trackViewpointChangedListenerEvents = false
        methodChannel.setMethodCallHandler(null)
        val lifecycle = lifecycleProvider.lifecycle
        lifecycle?.removeObserver(this)
        if (scaleBarController != null) {
            scaleBarController!!.dispose()
            scaleBarController = null
        }
        mapViewOnTouchListener!!.clearAllDelegates()
        mapViewOnTouchListener = null
        symbolVisibilityFilterController.clear()
        clearSymbolsControllers()
        clearMapAwareControllers()
        locationDisplayController.setLocationDisplayControllerDelegate(null)
        locationDisplayController.dispose()
        destroyMapViewIfNecessary()
    }

    override fun viewpointChanged(viewpointChangedEvent: ViewpointChangedEvent) {
        if (trackViewpointChangedListenerEvents) {
            methodChannel.invokeMethod("map#viewpointChanged", null)
        }
    }

    override fun timeExtentChanged(timeExtentChangedEvent: TimeExtentChangedEvent) {
        methodChannel.invokeMethod(
            "map#timeExtentChanged",
            Convert.Companion.timeExtentToJson(timeExtentChangedEvent.timeExtent)
        )
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
                val future = mapView!!.exportImageAsync()
                future!!.addDoneListener {
                    try {
                        val bitmap = future.get()
                        result.success(Convert.Companion.bitmapToByteArray(bitmap))
                    } catch (e: Exception) {
                        result.error("exportImage", e.message, null)
                    }
                }
            }

            "map#getLegendInfos" -> {
                val legendInfoController = LegendInfoController(context, layersController)
                legendInfoControllers.add(legendInfoController)
                legendInfoController.loadAsync(call.arguments) { results: List<Any?>? ->
                    result.success(results)
                    legendInfoControllers.remove(legendInfoController)
                }
            }

            "map#getMapMaxExtend" -> {
                if (mapView.getMap() != null) {
                    mapView.getMap().addDoneLoadingListener {
                        val maxExtend = mapView.getMap().maxExtent
                        if (maxExtend == null) {
                            result.success(null)
                        } else {
                            result.success(Convert.Companion.geometryToJson(maxExtend))
                        }
                    }
                } else {
                    result.success(null)
                }
            }

            "map#setMapMaxExtent" -> {
                val maxExtend = Convert.Companion.toGeometry(call.arguments) as Envelope
                if (mapView.getMap() != null) {
                    mapView.getMap().maxExtent = maxExtend
                }
                result.success(null)
            }

            "map#setMap" -> {
                changeMapType(call.arguments)
                result.success(null)
            }

            "map#setLayersChangedListener" -> {
                layersChangedController.setTrackLayersChange(call.arguments()!!)
                result.success(null)
            }

            "map#setTimeExtentChangedListener" -> {
                val track = call.arguments<Boolean>()!!
                if (trackTimeExtentEvents != track) {
                    trackTimeExtentEvents = track
                    if (trackTimeExtentEvents) {
                        mapView!!.addTimeExtentChangedListener(this)
                    } else {
                        mapView!!.removeTimeExtentChangedListener(this)
                    }
                }
                result.success(null)
            }

            "map#setViewpointChangedListenerEvents" -> {
                trackViewpointChangedListenerEvents = call.arguments()!!
                result.success(null)
            }

            "map#getTimeExtent" -> {
                result.success(Convert.Companion.timeExtentToJson(mapView.getTimeExtent()))
            }

            "map#setTimeExtent" -> {
                mapView.setTimeExtent(Convert.Companion.toTimeExtent(call.arguments))
                result.success(null)
            }

            "map#getMapRotation" -> {
                if (mapView.getMap() != null) {
                    result.success(mapView.getMapRotation())
                } else {
                    result.success(0.0)
                }
            }

            "map#getWanderExtentFactor" -> {
                result.success(mapView.getLocationDisplay().wanderExtentFactor)
            }

            "map#queryFeatureTableFromLayer" -> {
                val data = call.arguments<Map<String, *>>()
                if (mapView != null && data != null) {
                    val params = QueryParameters()
                    var layerName: String? = ""

                    // init query params
                    for ((key, value) in data) {
                        when (key) {
                            "layerName" -> layerName = value as String?
                            "objectId" -> params.objectIds.add(value as kotlin.String?. toLong ())
                            "maxResults" -> params.maxFeatures = value as kotlin.String?. toInt ()
                            "geometry" -> params.geometry = Convert.Companion.toGeometry(
                                value
                            )

                            "spatialRelationship" -> params.spatialRelationship =
                                Convert.Companion.toSpatialRelationship(
                                    value!!
                                )

                            else -> if (params.whereClause.isEmpty()) {
                                params.whereClause = String.format(
                                    "upper(%s) LIKE '%%%s%%'",
                                    key,
                                    value.toString().uppercase(Locale.getDefault())
                                )
                            } else {
                                val whereClause = params.whereClause
                                params.whereClause = whereClause + String.format(
                                    " AND upper(%s) LIKE '%%%s%%'",
                                    key,
                                    value.toString().uppercase(Locale.getDefault())
                                )
                            }
                        }
                    }

                    // check map
                    val map = mapView.getMap()
                    if (map == null || map.operationalLayers.size == 0) {
                        result.success(null)
                        return
                    }
                    val layers = map.operationalLayers
                    val finalLayerName = layerName
                    AGSLoadObjects.load(layers, LoadObjectsResult { loaded: Boolean ->
                        if (!loaded) {
                            result.success(null)
                            return@LoadObjectsResult
                        }
                        for (layer in layers) {
                            if (layer is FeatureLayer) {
                                val featureLayer = layer as FeatureLayer
                                if (featureLayer.name.equals(finalLayerName, ignoreCase = true)) {
                                    val future =
                                        featureLayer.featureTable.queryFeaturesAsync(params)
                                    future.addDoneListener {
                                        try {
                                            val queryResult = future.get()
                                            val results = ArrayList<Any>()
                                            for (feature in queryResult) {
                                                results.add(feature.toMap())
                                            }
                                            result.success(results)
                                        } catch (e: Exception) {
                                            result.success(null)
                                        }
                                    }
                                    return@LoadObjectsResult
                                }
                            } else if (layer is GroupLayer) {
                                val gLayer = layer as GroupLayer
                                for (layerItem in gLayer.layers) {
                                    if (layerItem is FeatureLayer) {
                                        val featureLayer = layerItem
                                        if (featureLayer.name.equals(
                                                finalLayerName,
                                                ignoreCase = true
                                            )
                                        ) {
                                            val future =
                                                featureLayer.featureTable.queryFeaturesAsync(params)
                                            future.addDoneListener {
                                                try {
                                                    val queryResult = future.get()
                                                    val results = ArrayList<Any>()
                                                    for (feature in queryResult) {
                                                        results.add(feature.toMap())
                                                    }
                                                    result.success(results)
                                                } catch (e: Exception) {
                                                    result.success(null)
                                                }
                                            }
                                            return@LoadObjectsResult
                                        }
                                    }
                                }
                            }
                        }
                        result.success(null)
                    })
                } else {
                    result.success(null)
                }
            }

            "map#getTimeAwareLayerInfos" -> handleTimeAwareLayerInfos(result)
            "map#getCurrentViewpoint" -> {
                val currentViewPoint =
                    mapView!!.getCurrentViewpoint(Convert.Companion.toViewpointType(call.arguments))
                if (currentViewPoint == null) {
                    result.success(null)
                } else {
                    result.success(Convert.Companion.viewpointToJson(currentViewPoint))
                }
            }

            "map#setViewpoint" -> {
                setViewpoint(call.arguments, true, result)
            }

            "map#setViewpointGeometry" -> {
                val data = call.arguments<Map<*, *>>()!!
                val geometry: Geometry = Convert.Companion.toGeometry(
                    data["geometry"]
                )
                val padding = data["padding"]
                val future: ListenableFuture<Boolean?>?
                future = if (padding == null) {
                    mapView!!.setViewpointGeometryAsync(geometry)
                } else {
                    val paddingDouble: Double = Convert.Companion.toDouble(padding)
                    mapView!!.setViewpointGeometryAsync(geometry, paddingDouble)
                }
                future.addDoneListener(Runnable {
                    try {
                        result.success(future.get())
                    } catch (e: Exception) {
                        Log.w(TAG, "map#setViewpointGeometry: ", e)
                        result.success(false)
                    }
                })
            }

            "map#setViewpointCenter" -> {
                val data = call.arguments<Map<*, *>>()!!
                val center: Point = Convert.Companion.toPoint(
                    data["center"]
                )
                val scale: Double = Convert.Companion.toDouble(
                    data["scale"]
                )
                val future = mapView!!.setViewpointCenterAsync(center, scale)
                future!!.addDoneListener {
                    try {
                        result.success(future.get())
                    } catch (e: Exception) {
                        Log.w(TAG, "map#setViewpointCenter: ", e)
                        result.success(false)
                    }
                }
            }

            "map#setViewpointRotation" -> {
                val angleDegrees: Double = Convert.Companion.toDouble(call.arguments)
                mapView!!.setViewpointRotationAsync(angleDegrees)
                    .addDoneListener { result.success(null) }
            }

            "map#locationToScreen" -> {
                val mapPoint: Point = Convert.Companion.toPoint(call.arguments)
                val screenPoint = mapView!!.locationToScreen(mapPoint)
                if (screenPoint == null) {
                    result.success(null)
                } else {
                    val screenPoints = DoubleArray(2)
                    screenPoints[0] = Convert.Companion.pixelsToDpF(
                        context, screenPoint.x.toFloat()
                    ).toDouble()
                    screenPoints[1] = Convert.Companion.pixelsToDpF(
                        context, screenPoint.y.toFloat()
                    ).toDouble()
                    result.success(screenPoints)
                }
            }

            "map#screenToLocation" -> {
                val screenLocationData: ScreenLocationData = Convert.Companion.toScreenLocationData(
                    context, call.arguments
                )
                var mapPoint = mapView!!.screenToLocation(screenLocationData.point)
                if (mapPoint == null) {
                    result.success(null)
                } else {
                    if (mapPoint.spatialReference.wkid != screenLocationData.spatialReference.wkid) {
                        mapPoint = GeometryEngine.project(
                            mapPoint,
                            screenLocationData.spatialReference
                        ) as Point
                    }
                    result.success(Convert.Companion.geometryToJson(mapPoint))
                }
            }

            "map#getMapScale" -> {
                if (mapView.getMap() != null) {
                    result.success(mapView.getMapScale())
                } else {
                    result.success(0.0)
                }
            }

            "layers#update" -> {
                invalidateMapHelper.invalidateMapIfNeeded()
                layersController.updateFromArgs(call.arguments)
                result.success(null)
            }

            "markers#update" -> {
                val markersToAdd = call.argument<List<Any?>>("markersToAdd")!!
                markersController.addMarkers(markersToAdd)
                val markersToChange = call.argument<List<Any?>>("markersToChange")!!
                markersController.changeMarkers(markersToChange)
                val markerIdsToRemove = call.argument<List<Any?>>("markerIdsToRemove")!!
                markersController.removeMarkers(markerIdsToRemove)
                invalidateMapHelper.invalidateMapIfNeeded()
                symbolVisibilityFilterController.invalidate()
                result.success(null)
            }

            "map#clearMarkerSelection" -> {
                invalidateMapHelper.invalidateMapIfNeeded()
                selectionPropertiesHandler.reset()
                markersController.clearSelectedMarker()
                result.success(null)
            }

            "polygons#update" -> {
                invalidateMapHelper.invalidateMapIfNeeded()
                val polygonsToAdd = call.argument<List<Any?>>("polygonsToAdd")!!
                polygonsController.addPolygons(polygonsToAdd)
                val polygonsToChange = call.argument<List<Any?>>("polygonsToChange")!!
                polygonsController.changePolygons(polygonsToChange)
                val polygonIdsToRemove = call.argument<List<Any?>>("polygonIdsToRemove")!!
                polygonsController.removePolygons(polygonIdsToRemove)
                result.success(null)
            }

            "polylines#update" -> {
                invalidateMapHelper.invalidateMapIfNeeded()
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
                val data = call.arguments<Map<*, *>>()
                if (mapView != null && data != null) {
                    val scale = data["scale"] as Double
                    val future = mapView!!.setViewpointScaleAsync(scale)
                    future!!.addDoneListener {
                        val scaled: Boolean
                        try {
                            scaled = future.get()!!
                            result.success(scaled)
                        } catch (e: ExecutionException) {
                            result.success(false)
                        } catch (e: InterruptedException) {
                            result.success(false)
                        }
                    }
                } else {
                    result.success(false)
                }
            }

            "map#getInitialViewpoint" -> {
                if (mapView == null) {
                    result.success(null)
                    return
                }
                val arcMap = mapView.getMap()
                if (arcMap == null) {
                    result.success(null)
                    return
                }
                val initialViewPoint = arcMap.initialViewpoint
                if (initialViewPoint == null) {
                    result.success(null)
                } else {
                    result.success(Convert.Companion.viewpointToJson(initialViewPoint))
                }
            }

            else -> result.notImplemented()
        }
    }

    override fun onCreate(owner: LifecycleOwner) {
        if (disposed) {
            return
        }
    }

    override fun onStart(owner: LifecycleOwner) {
        if (disposed) {
            return
        }
    }

    override fun onResume(owner: LifecycleOwner) {
        if (disposed) {
            return
        }
        mapView!!.resume()
    }

    override fun onPause(owner: LifecycleOwner) {
        if (disposed) {
            return
        }
        mapView!!.pause()
    }

    override fun onStop(owner: LifecycleOwner) {
        if (disposed) {
            return
        }
    }

    override fun onDestroy(owner: LifecycleOwner) {
        owner.lifecycle.removeObserver(this)
        if (disposed) {
            return
        }
        destroyMapViewIfNecessary()
    }

    private fun destroyMapViewIfNecessary() {
        mapLoadedListener.setMap(null)
        if (mapView != null) {
            mapView!!.dispose()
            mapView!!.removeAllViews()
            mapView = null
        }
    }

    private fun handleTimeAwareLayerInfos(result: MethodChannel.Result) {
        val map = mapView.getMap()
        if (map == null || map.operationalLayers.size == 0) {
            result.success(ArrayList<Any>())
            return
        }
        val layers = map.operationalLayers
        AGSLoadObjects.load(layers, LoadObjectsResult { loaded: Boolean ->
            if (!loaded) {
                result.success(ArrayList<Any>())
                return@LoadObjectsResult
            }
            val results = ArrayList<Any>()
            for (layer in layers) {
                if (layer is TimeAware) {
                    results.add(
                        Convert.Companion.timeAwareToJson(
                            layer as TimeAware,
                            layersController.getLayerIdByLayer(layer)
                        )
                    )
                }
            }
            result.success(results)
        })
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
        if (args == null) {
            result?.success(null)
            return
        }
        viewpoint = Convert.Companion.toViewPoint(args)
        if (mapView.getMap() == null) {
            result?.success(null)
            return
        }
        if (animated) {
            mapView!!.setViewpointAsync(viewpoint).addDoneListener { result?.success(null) }
        } else {
            mapView!!.setViewpointAsync(viewpoint, 0f).addDoneListener { result?.success(null) }
        }
        viewpoint = null
    }

    private fun changeMapType(args: Any?) {
        if (args == null) {
            return
        }
        val data: Map<*, *> = Convert.Companion.toMap(args)
        if (data.containsKey("offlinePath")) {
            loadOfflineMap(data)
            return
        }
        val map: ArcGISMap = Convert.Companion.toArcGISMap(args)
        changeMap(map)
    }

    private fun loadOfflineMap(data: Map<*, *>) {
        val offlinePath = data["offlinePath"] as String?
        val mapIndex = data["offlineMapIndex"] as Int
        val parts =
            offlinePath!!.split("\\.".toRegex()).dropLastWhile { it.isEmpty() }.toTypedArray()
        val ext = parts[parts.size - 1]
        when (ext) {
            "vtpk" -> {
                val baseLayer = ArcGISVectorTiledLayer(offlinePath)
                val baseMap = Basemap(baseLayer)
                val vMap = ArcGISMap()
                vMap.basemap = baseMap
                changeMap(vMap)
            }

            else -> {
                val mobileMapPackage = MobileMapPackage(offlinePath)
                mobileMapPackage.addDoneLoadingListener {
                    if (mobileMapPackage.loadStatus == LoadStatus.LOADED) {
                        val map = mobileMapPackage.maps[mapIndex]
                        changeMap(map)
                    } else {
                        Log.w(
                            TAG,
                            "loadOfflineMap: Failed to load map." + mobileMapPackage.loadError.message
                        )
                        if (mobileMapPackage.loadError.cause != null) {
                            Log.w(
                                TAG,
                                "loadOfflineMap: Failed to load map." + mobileMapPackage.loadError.cause!!.message
                            )
                            methodChannel.invokeMethod(
                                "map#loaded",
                                mobileMapPackage.loadError.cause!!.message
                            )
                        } else {
                            methodChannel.invokeMethod(
                                "map#loaded",
                                mobileMapPackage.loadError.message
                            )
                        }
                    }
                }
                mobileMapPackage.loadAsync()
            }
        }
    }

    private fun changeMap(map: ArcGISMap) {
        var viewpoint = viewpoint
        if (viewpoint == null) {
            viewpoint = mapView!!.getCurrentViewpoint(Viewpoint.Type.CENTER_AND_SCALE)
        }
        mapLoadedListener.setMap(map)
        map.loadAsync()
        mapView.setMap(map)
        updateMapScale()
        for (mapChangeAware in mapChangeAwares) {
            mapChangeAware.onMapChange(map)
        }
        if (viewpoint != null) {
            this.viewpoint = null
            val future = mapView!!.setViewpointAsync(viewpoint)
            future!!.addDoneListener { invalidateMapHelper.invalidateMapIfNeeded() }
        }
    }

    private fun updateMapOptions(args: Any?) {
        if (args == null) {
            return
        }
        val data = args as Map<*, *>
        if (mapView != null) {
            Convert.Companion.interpretMapViewOptions(data, mapView!!)
        }
        val trackUserLocationTap = data["trackUserLocationTap"]
        if (trackUserLocationTap != null) {
            locationDisplayController.setTrackUserLocationTap(
                Convert.Companion.toBoolean(
                    trackUserLocationTap
                )
            )
        }
        val trackIdentifyLayers = data["trackIdentifyLayers"]
        if (trackIdentifyLayers != null) {
            mapViewOnTouchListener!!.setTrackIdentityLayers(
                Convert.Companion.toBoolean(
                    trackIdentifyLayers
                )
            )
        }
        val haveScaleBar = data["haveScalebar"]
        if (haveScaleBar != null) {
            this.haveScaleBar = Convert.Companion.toBoolean(haveScaleBar)
        }
        val isAttributionTextVisible = data["isAttributionTextVisible"]
        if (isAttributionTextVisible != null && mapView != null) {
            mapView!!.setAttributionTextVisible(Convert.Companion.toBoolean(isAttributionTextVisible))
        }
        val contentInsets = data["contentInsets"]
        if (contentInsets != null && mapView != null) {
            // order is left,top,right,bottom
            val rect: List<*> = Convert.Companion.toList(contentInsets)
            mapView!!.setViewInsets(
                Convert.Companion.toDouble(
                    rect[0]
                ), Convert.Companion.toDouble(rect[1]), Convert.Companion.toDouble(
                    rect[2]
                ), Convert.Companion.toDouble(rect[3])
            )
        }
        val scaleBarConfiguration = data["scalebarConfiguration"]
        if (scaleBarConfiguration != null) {
            scaleBarController!!.interpretConfiguration(scaleBarConfiguration)
        } else if (!this.haveScaleBar) {
            scaleBarController!!.removeScaleBar()
        }
        val minScale = data["minScale"]
        if (minScale != null) {
            this.minScale = Convert.Companion.toDouble(minScale)
        }
        val maxScale = data["maxScale"]
        if (maxScale != null) {
            this.maxScale = Convert.Companion.toDouble(maxScale)
        }
        updateMapScale()
    }

    private fun initWithParams(params: Map<String, Any>?) {
        val mapType = params!!["map"]
        mapType?.let { changeMapType(it) }
        val viewPoint = params["viewpoint"]
        if (viewPoint != null) {
            setViewpoint(viewPoint, false, null)
        }
        val options = params["options"]
        options?.let { updateMapOptions(it) }
        layersController.updateFromArgs(params)
        val markersToAdd = params["markersToAdd"]
        if (markersToAdd != null) {
            markersController.addMarkers(markersToAdd as List<Any?>?)
        }
        val polygonsToAdd = params["polygonsToAdd"]
        if (polygonsToAdd != null) {
            polygonsController.addPolygons(polygonsToAdd as List<Any?>?)
        }
        val polylinesToAdd = params["polylinesToAdd"]
        if (polylinesToAdd != null) {
            polylinesController.addPolylines(polylinesToAdd as List<Any>?)
        }
    }

    private fun updateMapScale() {
        if (mapView != null && mapView.getMap() != null) {
            mapView.getMap().minScale = minScale
            mapView.getMap().maxScale = maxScale
        }
    }

    private inner class MapLoadedListener : Runnable {
        private var map: ArcGISMap? = null
        fun setMap(map: ArcGISMap?) {
            try {
                if (this.map != null) {
                    this.map!!.removeDoneLoadingListener(this)
                }
                this.map = map
                map?.addDoneLoadingListener(this)
            } catch (e: Exception) {
                Log.e(TAG, "setMap: ", e)
            }
        }

        override fun run() {
            if (disposed) {
                return
            }
            map!!.removeDoneLoadingListener(this)
            if (map!!.loadStatus == LoadStatus.LOADED) {
                methodChannel.invokeMethod("map#loaded", null)
            } else if (map!!.loadError != null) {
                Log.w(TAG, "changeMap: Failed to load map." + map!!.loadError.message)
                if (map!!.loadError.cause != null) {
                    Log.w(TAG, "changeMap: Failed to load map." + map!!.loadError.cause!!.message)
                }
                methodChannel.invokeMethod(
                    "map#loaded", Convert.Companion.arcGISRuntimeExceptionToJson(
                        map!!.loadError
                    )
                )
            } else {
                Log.w(TAG, "changeMap: Unknown error")
                methodChannel.invokeMethod("map#loaded", null)
            }
        }
    }

    companion object {
        private const val TAG = "ArcgisMapController"
    }
}