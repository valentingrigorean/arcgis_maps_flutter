package com.valentingrigorean.arcgis_maps_flutter

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Color
import android.graphics.Point
import android.icu.text.SimpleDateFormat
import android.util.DisplayMetrics
import android.util.Log
import android.util.TypedValue
import com.arcgismaps.BuildConfig
import com.arcgismaps.geometry.GeodesicSectorParameters
import com.arcgismaps.geometry.GeometryType
import com.arcgismaps.geometry.LinearUnitId
import com.arcgismaps.geometry.SpatialReference
import com.esri.arcgisruntime.ArcGISRuntimeException
import com.esri.arcgisruntime.UnitSystem
import com.esri.arcgisruntime.arcgisservices.LevelOfDetail
import com.esri.arcgisruntime.arcgisservices.TileInfo
import com.esri.arcgisruntime.arcgisservices.TimeAware
import com.esri.arcgisruntime.arcgisservices.TimeUnit
import com.esri.arcgisruntime.data.EditResult
import com.esri.arcgisruntime.data.FeatureEditResult
import com.esri.arcgisruntime.data.QueryParameters
import com.esri.arcgisruntime.data.TileCache
import com.esri.arcgisruntime.geometry.AngularUnit
import com.esri.arcgisruntime.geometry.AngularUnitId
import com.esri.arcgisruntime.geometry.AreaUnitId
import com.esri.arcgisruntime.geometry.Envelope
import com.esri.arcgisruntime.geometry.GeodesicSectorParameters
import com.esri.arcgisruntime.geometry.GeodeticCurveType
import com.esri.arcgisruntime.geometry.Geometry
import com.esri.arcgisruntime.geometry.GeometryType
import com.esri.arcgisruntime.geometry.LinearUnit
import com.esri.arcgisruntime.geometry.LinearUnitId
import com.esri.arcgisruntime.geometry.PointCollection
import com.esri.arcgisruntime.geometry.Polygon
import com.esri.arcgisruntime.geometry.Polyline
import com.esri.arcgisruntime.geometry.SpatialReference
import com.esri.arcgisruntime.loadable.Loadable
import com.esri.arcgisruntime.location.LocationDataSource
import com.esri.arcgisruntime.mapping.ArcGISMap
import com.esri.arcgisruntime.mapping.ArcGISScene
import com.esri.arcgisruntime.mapping.ArcGISTiledElevationSource
import com.esri.arcgisruntime.mapping.Basemap
import com.esri.arcgisruntime.mapping.BasemapStyle
import com.esri.arcgisruntime.mapping.ElevationSource
import com.esri.arcgisruntime.mapping.GeoElement
import com.esri.arcgisruntime.mapping.Surface
import com.esri.arcgisruntime.mapping.TimeExtent
import com.esri.arcgisruntime.mapping.TimeValue
import com.esri.arcgisruntime.mapping.Viewpoint
import com.esri.arcgisruntime.mapping.view.Camera
import com.esri.arcgisruntime.mapping.view.IdentifyLayerResult
import com.esri.arcgisruntime.mapping.view.LocationDisplay.AutoPanMode
import com.esri.arcgisruntime.portal.Portal
import com.esri.arcgisruntime.portal.PortalItem
import com.esri.arcgisruntime.security.Credential
import com.esri.arcgisruntime.security.UserCredential
import com.esri.arcgisruntime.symbology.SimpleLineSymbol
import com.esri.arcgisruntime.symbology.SimpleMarkerSymbol
import com.esri.arcgisruntime.tasks.geocode.GeocodeResult
import com.esri.arcgisruntime.tasks.geodatabase.SyncGeodatabaseParameters
import com.fasterxml.jackson.core.JsonProcessingException
import com.fasterxml.jackson.core.type.TypeReference
import com.fasterxml.jackson.databind.ObjectMapper
import com.valentingrigorean.arcgis_maps_flutter.data.FieldTypeFlutter
import com.valentingrigorean.arcgis_maps_flutter.layers.FlutterLayer
import com.valentingrigorean.arcgis_maps_flutter.layers.FlutterLayer.ServiceImageTiledLayerOptions
import com.valentingrigorean.arcgis_maps_flutter.map.BitmapDescriptorFactory
import com.valentingrigorean.arcgis_maps_flutter.map.FlutterMapViewDelegate
import com.valentingrigorean.arcgis_maps_flutter.map.GraphicControllerSink
import com.valentingrigorean.arcgis_maps_flutter.map.MarkerController
import com.valentingrigorean.arcgis_maps_flutter.map.PolygonController
import com.valentingrigorean.arcgis_maps_flutter.map.PolylineController
import com.valentingrigorean.arcgis_maps_flutter.map.ScreenLocationData
import com.valentingrigorean.arcgis_maps_flutter.map.SymbolVisibilityFilter
import com.valentingrigorean.arcgis_maps_flutter.map.SymbolVisibilityFilterController
import com.valentingrigorean.arcgis_maps_flutter.toolkit.scalebar.Scalebar
import com.valentingrigorean.arcgis_maps_flutter.toolkit.scalebar.style.Style
import com.valentingrigorean.arcgis_maps_flutter.utils.LoadStatusChangedListenerLogger
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer
import java.util.Calendar
import java.util.GregorianCalendar
import java.util.Locale
import java.util.Objects
import java.util.UUID
import java.util.stream.Collectors

open class Convert {
    companion object {
        private const val TAG = "Convert"
        private val TYPE_REFERENCE: TypeReference<Map<String?, Any?>?> =
            object : TypeReference<Map<String?, Any?>?>() {}
        protected val ISO8601Format = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSXXX", Locale.US)
        protected val objectMapper = ObjectMapper()
        fun pointToJson(screenPoint: Point): Any {
            val data = DoubleArray(2)
            data[0] = screenPoint.x.toDouble()
            data[1] = screenPoint.y.toDouble()
            return data
        }

        fun arcGISRuntimeExceptionToJson(ex: ArcGISRuntimeException?): Any? {
            if (ex == null) {
                return null
            }
            val map = HashMap<String, Any?>()
            map["code"] = ex.errorCode
            map["message"] = ex.message
            map["additionalMessage"] = ex.additionalMessage
            if (ex.cause != null) {
                map["innerErrorMessage"] = ex.cause!!.message
            }
            map["errorDomain"] = ex.errorDomain.ordinal
            return map
        }

        fun exceptionToJson(ex: Exception?): Any? {
            if (ex == null) {
                return null
            }
            if (ex is ArcGISRuntimeException) {
                return arcGISRuntimeExceptionToJson(ex as ArcGISRuntimeException?)
            }
            val map = HashMap<String, Any?>()
            map["message"] = ex.message
            if (ex.cause != null) {
                map["innerErrorMessage"] = ex.cause!!.message
            }
            return map
        }

        fun toScaleBarAlignment(rawValue: Int): Scalebar.Alignment {
            return when (rawValue) {
                0 -> Scalebar.Alignment.LEFT
                1 -> Scalebar.Alignment.RIGHT
                2 -> Scalebar.Alignment.CENTER
                else -> throw IllegalStateException("Unexpected value: $rawValue")
            }
        }



        fun toSpatialRelationship(o: Any): QueryParameters.SpatialRelationship {
            return when (toInt(o)) {
                -1 -> QueryParameters.SpatialRelationship.UNKNOWN
                0 -> QueryParameters.SpatialRelationship.RELATE
                1 -> QueryParameters.SpatialRelationship.EQUALS
                2 -> QueryParameters.SpatialRelationship.DISJOINT
                3 -> QueryParameters.SpatialRelationship.INTERSECTS
                4 -> QueryParameters.SpatialRelationship.TOUCHES
                5 -> QueryParameters.SpatialRelationship.CROSSES
                6 -> QueryParameters.SpatialRelationship.WITHIN
                7 -> QueryParameters.SpatialRelationship.CONTAINS
                8 -> QueryParameters.SpatialRelationship.OVERLAPS
                9 -> QueryParameters.SpatialRelationship.ENVELOPE_INTERSECTS
                10 -> QueryParameters.SpatialRelationship.INDEX_INTERSECTS
                else -> throw IllegalStateException("Unexpected value: $o")
            }
        }

        fun spatialRelationshipToJson(spatialRelationship: QueryParameters.SpatialRelationship): Int {
            return when (spatialRelationship) {
                QueryParameters.SpatialRelationship.UNKNOWN -> -1
                QueryParameters.SpatialRelationship.RELATE -> 0
                QueryParameters.SpatialRelationship.EQUALS -> 1
                QueryParameters.SpatialRelationship.DISJOINT -> 2
                QueryParameters.SpatialRelationship.INTERSECTS -> 3
                QueryParameters.SpatialRelationship.TOUCHES -> 4
                QueryParameters.SpatialRelationship.CROSSES -> 5
                QueryParameters.SpatialRelationship.WITHIN -> 6
                QueryParameters.SpatialRelationship.CONTAINS -> 7
                QueryParameters.SpatialRelationship.OVERLAPS -> 8
                QueryParameters.SpatialRelationship.ENVELOPE_INTERSECTS -> 9
                QueryParameters.SpatialRelationship.INDEX_INTERSECTS -> 10
                else -> throw IllegalStateException("Unexpected value: $spatialRelationship")
            }
        }

        fun toScaleBarStyle(rawValue: Int): Style {
            return when (rawValue) {
                0 -> Style.LINE
                1 -> Style.BAR
                2 -> Style.GRADUATED_LINE
                3 -> Style.ALTERNATING_BAR
                4 -> Style.DUAL_UNIT_LINE
                5 -> Style.DUAL_UNIT_LINE_NAUTICAL_MILE
                else -> throw IllegalStateException("Unexpected value: $rawValue")
            }
        }

        fun toUnitSystem(rawValue: Int): UnitSystem {
            return when (rawValue) {
                0 -> UnitSystem.IMPERIAL
                1 -> UnitSystem.METRIC
                else -> throw IllegalStateException("Unexpected value: $rawValue")
            }
        }

        fun locationToJson(location: LocationDataSource.Location): Any {
            val json: MutableMap<String, Any?> = HashMap(7)
            json["course"] = location.course
            json["horizontalAccuracy"] = location.horizontalAccuracy
            json["lastKnown"] = location.isLastKnown
            if (location.position != null) {
                json["position"] =
                    geometryToJson(location.position)
            }
            json["velocity"] = location.velocity
            json["timestamp"] =
                ISO8601Format.format(location.timeStamp.time)
            json["verticalAccuracy"] = location.verticalAccuracy
            return json
        }

        fun viewpointToJson(viewpoint: Viewpoint): Any? {
            try {
                val json = viewpoint.toJson()
                return objectMapper.readValue(json, TYPE_REFERENCE)
            } catch (e: Exception) {
                e.printStackTrace()
            }
            return null
        }



        fun geoElementToJson(element: GeoElement): Any? {
            val attributes: MutableMap<String, Any> = HashMap(element.attributes.size)
            element.attributes.forEach { (k: String, v: Any?) ->
                attributes[k] = toFlutterFieldType(v)
            }
            val elementData: MutableMap<String, Any?> = HashMap(2)
            elementData["attributes"] = attributes
            if (element.geometry != null) elementData["geometry"] = geometryToJson(element.geometry)
            return elementData
        }


        fun toEnvelope(o: Any): Envelope? {
            val data = toMap(o)
            val spatialReference = toSpatialReference(
                data["spatialReference"]
            )
            if (data.containsKey("xmin")) {
                val xmin = toDouble(
                    data["xmin"]
                )
                val ymin = toDouble(
                    data["ymin"]
                )
                val xmax = toDouble(
                    data["xmax"]
                )
                val ymax = toDouble(
                    data["ymax"]
                )
                return Envelope(xmin, ymin, xmax, ymax, spatialReference)
            }
            if (data.containsKey("bbox")) {
                val bbox = toDoubleArray(
                    data["bbox"]
                )
                return Envelope(bbox!![0], bbox[1], bbox[2], bbox[3], spatialReference)
            }
            return null
        }

        fun toViewPoint(o: Any): Viewpoint {
            val data = toMap(o)
            val scale = toDouble(Objects.requireNonNull(data)["scale"])
            val targetGeometry = toPoint(
                data["targetGeometry"]
            )
            return Viewpoint(targetGeometry, scale)
        }

        fun toCredentials(o: Any?): Credential {
            val map = toMap(
                o!!
            )
            val type = Objects.requireNonNull(map)["type"] as String?
            if ("UserCredential" == type) {
                val referer = map["referer"]
                val token = map["token"]
                if (token != null) {
                    return UserCredential.createFromToken(token as String?, referer as String?)
                }
                val username = map["username"] as String?
                val password = map["password"] as String?
                return UserCredential(username, password, referer as String?)
            }
            throw UnsupportedOperationException("Not implemented.")
        }

        fun credentialToJson(credential: Credential?): Any? {
            if (credential is UserCredential) {
                val userCredential = credential
                val map: MutableMap<String, Any> = HashMap(5)
                map["type"] = "UserCredential"
                map["username"] = userCredential.username
                map["password"] = userCredential.password
                map["referer"] = userCredential.referer
                map["token"] = userCredential.token
                return map
            }
            return null
        }

        fun toCamera(o: Any?): Camera {
            val data = toMap(
                o!!
            )
            val heading = toDouble(
                Objects.requireNonNull(data)["heading"]
            )
            val pitch = toDouble(data["pitch"])
            val roll = toDouble(data["roll"])
            if (data.containsKey("cameraLocation")) {
                val point = toPoint(
                    data["cameraLocation"]
                )
                return Camera(point, heading, pitch, roll)
            }
            val latitude = toDouble(
                data["latitude"]
            )
            val longitude = toDouble(
                data["longitude"]
            )
            val altitude = toDouble(
                data["altitude"]
            )
            return Camera(latitude, longitude, altitude, heading, pitch, roll)
        }

        fun toScene(o: Any): ArcGISScene {
            val data = toMap(o)
            if (data.containsKey("json")) {
                return ArcGISScene.fromJson(data["json"] as String?)
            }
            val basemap = createBasemapFromType(
                data["basemap"] as String?
            )
            return ArcGISScene(basemap)
        }

        fun toSurface(o: Any): Surface {
            val data = toMap(o)
            val alpha = toFloat(Objects.requireNonNull(data)["alpha"])
            val isEnabled = toBoolean(
                data["isEnabled"]!!
            )
            var elevationSources: List<ElevationSource?>? = null
            if (data.containsKey("elevationSources")) {
                elevationSources = toElevationSourceList(
                    data["elevationSources"] as List<*>?
                )
            }
            val surface: Surface
            surface = if (elevationSources != null) {
                Surface(elevationSources)
            } else {
                Surface()
            }
            surface.isEnabled = isEnabled
            surface.opacity = alpha
            if (data.containsKey("elevationExaggeration")) {
                surface.elevationExaggeration = toFloat(
                    data["elevationExaggeration"]
                )
            }
            return surface
        }

        fun toArcGISMap(o: Any): ArcGISMap {
            val data = toMap(o)
            val baseMap = data["baseMap"]
            var arcGISMap: ArcGISMap? = null
            if (baseMap != null) {
                val basemap = createBasemapFromType(baseMap as String?)
                attachLoadableLogger("BASEMAP", basemap)
                arcGISMap = ArcGISMap(basemap)
            }
            val baseLayer = data["baseLayer"]
            if (baseLayer != null) {
                val layer = FlutterLayer(toMap(baseLayer))
                val nativeLayer = layer.createLayer()
                attachLoadableLogger("BASE_LAYER:" + layer.layerId, nativeLayer!!)
                arcGISMap = ArcGISMap(Basemap(nativeLayer))
            }
            val portalItem = data["portalItem"]
            if (portalItem != null) {
                val basemap = Basemap(toPortalItem(portalItem))
                attachLoadableLogger("BASEMAP", basemap)
                arcGISMap = ArcGISMap(basemap)
            }
            val basemapTypeOptionsRaw = data["basemapTypeOptions"]
            if (basemapTypeOptionsRaw != null) {
                val basemapTypeOptions = toMap(basemapTypeOptionsRaw)
                val type = getBasemapType(
                    basemapTypeOptions["basemapType"] as String?
                )
                val latitude = toDouble(
                    basemapTypeOptions["latitude"]
                )
                val longitude = toDouble(
                    basemapTypeOptions["longitude"]
                )
                val levelOfDetail = toInt(
                    basemapTypeOptions["levelOfDetail"]
                )
                arcGISMap = ArcGISMap(type, latitude, longitude, levelOfDetail)
            }
            if (arcGISMap == null) {
                arcGISMap = ArcGISMap()
            }
            attachLoadableLogger("MAP", arcGISMap)
            return arcGISMap
        }

        fun toServiceImageTiledLayerOptions(o: Any): ServiceImageTiledLayerOptions {
            val data = toMap(o)
            return ServiceImageTiledLayerOptions(
                toTileInfo(Objects.requireNonNull(data)["tileInfo"]),
                toEnvelop(data["fullExtent"]),
                data["url"].toString(),
                data["subdomains"] as List<String?>?,
                data["additionalOptions"] as Map<String?, String?>?
            )
        }

        fun toTileInfo(o: Any?): TileInfo {
            val data = toMap(
                o!!
            )
            val dpi = toInt(data["dpi"])
            val imageFormat = toInt(
                data["imageFormat"]
            )
            val levelOfDetails = toList(
                data["levelOfDetails"]!!
            ).stream().map { o: Any -> toLevelOfDetail(o) }
                .collect(Collectors.toList())
            val origin = toPoint(data["origin"])
            val spatialReference = toSpatialReference(
                data["spatialReference"]
            )
            val tileHeight = toInt(
                data["tileHeight"]
            )
            val tileWidth = toInt(data["tileWidth"])
            return TileInfo(
                dpi,
                if (imageFormat == -1) TileInfo.ImageFormat.UNKNOWN else TileInfo.ImageFormat.values()[imageFormat],
                levelOfDetails,
                origin,
                spatialReference,
                tileHeight,
                tileWidth
            )
        }

        fun toTileCache(o: Any): TileCache {
            val data = toMap(o)
            val url = data["url"].toString()
            return TileCache(url)
        }

        fun toLevelOfDetail(o: Any): LevelOfDetail {
            val data = toList(o)
            return LevelOfDetail(
                toInt(
                    data[0]
                ), toDouble(data[1]), toDouble(
                    data[2]
                )
            )
        }

        fun toEnvelop(o: Any?): Envelope {
            val data = toMap(
                o!!
            )
            val bbox = toList(
                data["bbox"]!!
            )
            val spatialReference = toSpatialReference(
                data["spatialReference"]
            )
            if (bbox.size == 4) {
                return Envelope(
                    toDouble(
                        bbox[0]
                    ), toDouble(bbox[1]), toDouble(
                        bbox[2]
                    ), toDouble(bbox[3]), spatialReference
                )
            }
            throw UnsupportedOperationException("Not implemented!")
        }


        fun interpretMapViewOptions(o: Any, flutterMapViewDelegate: FlutterMapViewDelegate) {
            val data = toMap(o)
            val interactionOptions = data["interactionOptions"]
            if (interactionOptions != null) {
                interpretInteractionOptions(interactionOptions, flutterMapViewDelegate)
            }
        }

        fun toViewpointType(o: Any?): Viewpoint.Type {
            return when (toInt(o)) {
                0 -> Viewpoint.Type.CENTER_AND_SCALE
                1 -> Viewpoint.Type.BOUNDING_GEOMETRY
                else -> Viewpoint.Type.UNKNOWN
            }
        }

        fun toSymbolVisibilityFilter(o: Any?): SymbolVisibilityFilter? {
            if (o == null) {
                return null
            }
            val data = toMap(o)
            val minZoom = toDouble(
                data["minZoom"]
            )
            val maxZoom = toDouble(
                data["maxZoom"]
            )
            return SymbolVisibilityFilter(minZoom, maxZoom)
        }

        fun interpretMarkerController(
            o: Any,
            controller: MarkerController,
            symbolVisibilityFilterController: SymbolVisibilityFilterController?
        ) {
            val data = toMap(o)
            interpretBaseGraphicController(data, controller, symbolVisibilityFilterController)
            val position = data["position"]
            if (position != null) {
                controller.setGeometry(toPoint(position))
            }
            val icon = data["icon"]
            if (icon != null) {
                controller.setIcon(BitmapDescriptorFactory.fromRawData(controller.context, icon))
            }
            val backgroundImage = data["backgroundImage"]
            if (backgroundImage != null) {
                controller.setBackground(
                    BitmapDescriptorFactory.fromRawData(
                        controller.context,
                        backgroundImage
                    )
                )
            }
            controller.setIconOffset(
                toFloat(
                    data["iconOffsetX"]
                ), toFloat(data["iconOffsetY"])
            )
            val opacity = data["opacity"]
            if (opacity != null) {
                controller.setOpacity(toFloat(opacity))
            }
            val angle = data["angle"]
            if (angle != null) {
                controller.setAngle(toFloat(angle))
            }
            val selectedScale = data["selectedScale"]
            if (selectedScale != null) {
                controller.setSelectedScale(toFloat(selectedScale))
            }
        }

        fun interpretPolygonController(
            o: Any,
            controller: PolygonController,
            symbolVisibilityFilterController: SymbolVisibilityFilterController?
        ) {
            val data = toMap(o)
            interpretBaseGraphicController(data, controller, symbolVisibilityFilterController)
            val fillColor = data["fillColor"]
            if (fillColor != null) {
                controller.setFillColor(toInt(fillColor))
            }
            val strokeColor = data["strokeColor"]
            if (strokeColor != null) {
                controller.setStrokeColor(toInt(strokeColor))
            }
            val strokeWidth = data["strokeWidth"]
            if (strokeWidth != null) {
                controller.setStrokeWidth(toInt(strokeWidth).toFloat())
            }
            val strokeStyle = data["strokeStyle"]
            if (strokeStyle != null) {
                controller.setStrokeStyle(toSimpleLineStyle(toInt(strokeStyle)))
            }
            val pointsRaw = data["points"]
            if (pointsRaw != null) {
                val points = toList(pointsRaw)
                val nativePoints = ArrayList<com.esri.arcgisruntime.geometry.Point>(points.size)
                for (point in points) {
                    nativePoints.add(toPoint(point))
                }
                controller.setGeometry(Polygon(PointCollection(nativePoints)))
            }
        }

        fun interpretPolylineController(
            o: Any,
            controller: PolylineController,
            symbolVisibilityFilterController: SymbolVisibilityFilterController?
        ) {
            val data = toMap(o)
            interpretBaseGraphicController(data, controller, symbolVisibilityFilterController)
            val color = data["color"]
            if (color != null) {
                controller.setColor(toInt(color))
            }
            val style = data["style"]
            if (style != null) {
                controller.setStyle(toSimpleLineStyle(toInt(style)))
            }
            val width = data["width"]
            if (width != null) {
                controller.setWidth(toInt(width).toFloat())
            }
            val antialias = data["antialias"]
            if (antialias != null) {
                controller.setAntialias(toBoolean(antialias))
            }
            val pointsRaw = data["points"]
            if (pointsRaw != null) {
                val points = toList(pointsRaw)
                val nativePoints = ArrayList<com.esri.arcgisruntime.geometry.Point>(points.size)
                for (point in points) {
                    nativePoints.add(toPoint(point))
                }
                controller.setGeometry(Polyline(PointCollection(nativePoints)))
            }
        }

        fun toBitmap(o: Any): Bitmap {
            val bmpData = o as ByteArray
            val bitmap = BitmapFactory.decodeByteArray(bmpData, 0, bmpData.size)
            return bitmap
                ?: throw IllegalArgumentException("Unable to decode bytes as a valid bitmap.")
        }

        fun bitmapToByteArray(bmp: Bitmap?): ByteArray? {
            if (bmp == null) {
                return null
            }
            val stream = ByteArrayOutputStream()
            bmp.compress(Bitmap.CompressFormat.PNG, 100, stream)
            return stream.toByteArray()
        }

        fun toSimpleMarkerSymbolStyle(rawValue: Int): SimpleMarkerSymbol.Style {
            return when (rawValue) {
                0 -> SimpleMarkerSymbol.Style.CIRCLE
                1 -> SimpleMarkerSymbol.Style.CROSS
                2 -> SimpleMarkerSymbol.Style.DIAMOND
                3 -> SimpleMarkerSymbol.Style.SQUARE
                4 -> SimpleMarkerSymbol.Style.TRIANGLE
                5 -> SimpleMarkerSymbol.Style.X
                else -> throw IllegalStateException("Unexpected value: $rawValue")
            }
        }

        fun timeAwareToJson(timeAware: TimeAware, layerId: String?): Any {
            val json: MutableMap<String, Any> = HashMap(6)
            if (layerId != null) {
                json["layerId"] = layerId
            }
            if (timeAware.fullTimeExtent != null) {
                val fullTimeExtentData = timeExtentToJson(timeAware.fullTimeExtent)
                if (fullTimeExtentData != null) {
                    json["fullTimeExtent"] = fullTimeExtentData
                }
            }
            json["supportsTimeFiltering"] = timeAware.isTimeFilteringSupported
            json["isTimeFilteringEnabled"] = timeAware.isTimeFilteringEnabled
            if (timeAware.timeOffset != null) {
                json["timeOffset"] =
                    timeValueToJson(timeAware.timeOffset)
            }
            if (timeAware.timeInterval != null) {
                json["timeInterval"] =
                    timeValueToJson(timeAware.timeInterval)
            }
            return json
        }

        fun timeExtentToJson(timeExtent: TimeExtent?): Any? {
            if (timeExtent == null) {
                return null
            }
            if (timeExtent.startTime == null && timeExtent.endTime == null) {
                return null
            }
            val json: MutableMap<Any, Any> = HashMap(2)
            if (timeExtent.startTime != null) {
                json["startTime"] =
                    ISO8601Format.format(timeExtent.startTime.time)
            }
            if (timeExtent.endTime != null) {
                json["endTime"] =
                    ISO8601Format.format(timeExtent.endTime.time)
            }
            return json
        }

        fun toTimeExtent(o: Any?): TimeExtent? {
            if (o == null) {
                return null
            }
            val data = toMap(o)
            val startTime = data["startTime"]
            val endTime = data["endTime"]
            return if (startTime == null && endTime == null) {
                null
            } else TimeExtent(
                Objects.requireNonNull(
                    toCalendarFromISO8601(
                        startTime
                    )
                ),
                Objects.requireNonNull(
                    toCalendarFromISO8601(
                        endTime
                    )
                )
            )
        }

        fun markerIdToJson(markerId: String?): Any? {
            if (markerId == null) {
                return null
            }
            val data: MutableMap<String, Any> = HashMap(1)
            data["markerId"] = markerId
            return data
        }

        fun polygonIdToJson(polygonId: String?): Any? {
            if (polygonId == null) {
                return null
            }
            val data: MutableMap<String, Any> = HashMap(1)
            data["polygonId"] = polygonId
            return data
        }

        fun polylineIdToJson(polylineId: String?): Any? {
            if (polylineId == null) {
                return null
            }
            val data: MutableMap<String, Any> = HashMap(1)
            data["polylineId"] = polylineId
            return data
        }

        fun toScreenLocationData(context: Context, o: Any): ScreenLocationData {
            val data = toMap(o)
            val points = toList(
                data["position"]!!
            )
            val spatialReferences = toSpatialReference(
                data["spatialReference"]
            )
            val x = toInt(points[0])
            val y = toInt(points[1])
            return ScreenLocationData(
                Point(dpToPixelsI(context, x), dpToPixelsI(context, y)),
                spatialReferences
            )
        }

        fun identifyLayerResultToJson(layerResult: IdentifyLayerResult?): Any? {
            if (layerResult == null) {
                return null
            }
            val data: MutableMap<String, Any> = HashMap(2)
            data["layerName"] = layerResult.layerContent.name
            val elements: MutableList<Any> = ArrayList(layerResult.elements.size)
            for (element in layerResult.elements) {
                if (element.attributes.size == 0) continue
                val attributes: MutableMap<String, Any> = HashMap(element.attributes.size)
                element.attributes.forEach { (k: String, v: Any?) ->
                    attributes[k] = toFlutterFieldType(v)
                }
                val elementData: MutableMap<String, Any?> = HashMap(2)
                elementData["attributes"] = attributes
                if (element.geometry != null) elementData["geometry"] =
                    geometryToJson(element.geometry)
                elements.add(elementData)
            }
            data["elements"] = elements
            return data
        }

        fun identifyLayerResultsToJson(layerResults: List<IdentifyLayerResult>): Any {
            val results: MutableList<Any?> = ArrayList(layerResults.size)
            for (result in layerResults) {
                results.add(identifyLayerResultToJson(result))
            }
            return results
        }

        fun editResultToJson(editResult: EditResult): Any {
            val data: MutableMap<String, Any?> = HashMap(6)
            data["completedWithErrors"] = editResult.hasCompletedWithErrors()
            data["editOperation"] =
                if (editResult.editOperation == EditResult.EditOperation.UNKNOWN) -1 else editResult.editOperation.ordinal
            if (editResult.hasCompletedWithErrors()) {
                data["error"] =
                    arcGISRuntimeExceptionToJson(
                        editResult.error
                    )
            }
            data["globalId"] = editResult.globalId
            data["objectId"] = editResult.objectId
            return data
        }

        fun featureEditResultToJson(featureEditResult: FeatureEditResult): Any {
            val data = editResultToJson(featureEditResult) as MutableMap<String, Any>
            val attachmentResults = ArrayList<Any>(featureEditResult.attachmentResults.size)
            for (attachmentResult in featureEditResult.attachmentResults) {
                attachmentResults.add(editResultToJson(attachmentResult))
            }
            data["attachmentResults"] = attachmentResults
            return data
        }

        fun toLinearUnitId(o: Any?): LinearUnitId {
            val index = toInt(o)
            return when (index) {
                0 -> LinearUnitId.CENTIMETERS
                1 -> LinearUnitId.FEET
                2 -> LinearUnitId.INCHES
                3 -> LinearUnitId.KILOMETERS
                4 -> LinearUnitId.METERS
                5 -> LinearUnitId.MILES
                6 -> LinearUnitId.NAUTICAL_MILES
                7 -> LinearUnitId.YARDS
                else -> LinearUnitId.OTHER
            }
        }

        fun toAreaUnitId(o: Any?): AreaUnitId {
            val index = toInt(o)
            return when (index) {
                0 -> AreaUnitId.ACRES
                1 -> AreaUnitId.HECTARES
                2 -> AreaUnitId.SQUARE_CENTIMETERS
                3 -> AreaUnitId.SQUARE_DECIMETERS
                4 -> AreaUnitId.SQUARE_FEET
                5 -> AreaUnitId.SQUARE_METERS
                6 -> AreaUnitId.SQUARE_KILOMETERS
                7 -> AreaUnitId.SQUARE_MILES
                8 -> AreaUnitId.SQUARE_MILLIMETERS
                9 -> AreaUnitId.SQUARE_YARDS
                else -> AreaUnitId.OTHER
            }
        }

        fun toAngularUnitId(o: Any?): AngularUnitId {
            val index = toInt(o)
            return AngularUnitId.values()[index]
        }

        fun toGeodeticCurveType(o: Any?): GeodeticCurveType {
            val index = toInt(o)
            return GeodeticCurveType.values()[index]
        }

        private fun interpretBaseGraphicController(
            data: Map<*, *>,
            controller: GraphicControllerSink,
            symbolVisibilityFilterController: SymbolVisibilityFilterController?
        ) {
            val consumeTapEvents = data["consumeTapEvents"]
            if (consumeTapEvents != null) {
                controller.setConsumeTapEvents(toBoolean(consumeTapEvents))
            }
            val visible = data["visible"]
            if (visible != null) {
                val visibilityFilter = data["visibilityFilter"]
                if (symbolVisibilityFilterController != null && visibilityFilter != null) {
                    symbolVisibilityFilterController.addGraphicsController(
                        controller,
                        toSymbolVisibilityFilter(visibilityFilter),
                        toBoolean(visible)
                    )
                } else {
                    controller.visible = toBoolean(visible)
                }
            }
            val zIndex = data["zIndex"]
            if (zIndex != null) {
                controller.setZIndex(toInt(zIndex))
            }
            val selectedColor = data["selectedColor"]
            if (selectedColor != null) {
                controller.setSelectedColor(Color.valueOf(toInt(selectedColor)))
            }
        }

        private fun interpretInteractionOptions(
            o: Any,
            flutterMapViewDelegate: FlutterMapViewDelegate
        ) {
            val data = toMap(o)
            val interactionOptions = flutterMapViewDelegate.interactionOptions ?: return
            val isEnabled = data["isEnabled"]
            if (isEnabled != null) {
                interactionOptions.isEnabled =
                    toBoolean(isEnabled)
            }
            val isRotateEnabled = data["isRotateEnabled"]
            if (isRotateEnabled != null) {
                interactionOptions.isRotateEnabled =
                    toBoolean(isRotateEnabled)
            }
            val isPanEnabled = data["isPanEnabled"]
            if (isPanEnabled != null) {
                interactionOptions.isPanEnabled =
                    toBoolean(isPanEnabled)
            }
            val isZoomEnabled = data["isZoomEnabled"]
            if (isZoomEnabled != null) {
                interactionOptions.isZoomEnabled =
                    toBoolean(isZoomEnabled)
            }
            val isMagnifierEnabled = data["isMagnifierEnabled"]
            if (isMagnifierEnabled != null) {
                interactionOptions.isMagnifierEnabled =
                    toBoolean(isMagnifierEnabled)
            }
            val allowMagnifierToPan = data["allowMagnifierToPan"]
            if (allowMagnifierToPan != null) {
                interactionOptions.setCanMagnifierPanMap(toBoolean(allowMagnifierToPan))
            }
        }

        private fun toSimpleLineStyle(rawValue: Int): SimpleLineSymbol.Style {
            return when (rawValue) {
                0 -> SimpleLineSymbol.Style.DASH
                1 -> SimpleLineSymbol.Style.DASH_DOT
                2 -> SimpleLineSymbol.Style.DASH_DOT_DOT
                3 -> SimpleLineSymbol.Style.DOT
                4 -> SimpleLineSymbol.Style.NULL
                5 -> SimpleLineSymbol.Style.SOLID
                else -> throw IllegalStateException("Unexpected value: $rawValue")
            }
        }

        fun toAutoPanMode(rawValue: Any?): AutoPanMode {
            val intValue = toInt(rawValue)
            return when (intValue) {
                0 -> AutoPanMode.OFF
                1 -> AutoPanMode.RECENTER
                2 -> AutoPanMode.NAVIGATION
                3 -> AutoPanMode.COMPASS_NAVIGATION
                else -> throw IllegalStateException("Unexpected value: $intValue")
            }
        }

        fun toPortal(o: Any?): Portal {
            val data = toMap(
                o!!
            )
            val postalUrl = data["postalUrl"] as String?
            val loginRequired = toBoolean(
                data["loginRequired"]!!
            )
            val portal = Portal(postalUrl, loginRequired)
            val credentials = data["credential"]
            if (credentials != null) {
                portal.credential = toCredentials(credentials)
            }
            attachLoadableLogger("PORTAL", portal)
            return portal
        }

        fun toPortalItem(o: Any?): PortalItem {
            val data = toMap(
                o!!
            )
            val portal = toPortal(data["portal"])
            val itemId = data["itemId"] as String?
            val portalItem = PortalItem(portal, itemId)
            attachLoadableLogger("PORTAL_ITEM:" + portalItem.itemId, portalItem)
            return portalItem
        }

        private fun createBasemapFromType(type: String?): Basemap {
            return when (type) {
                "streets", "streetsVector" -> Basemap(BasemapStyle.ARCGIS_STREETS)
                "topographic", "topographicVector" -> Basemap(BasemapStyle.ARCGIS_TOPOGRAPHIC)
                "imagery" -> Basemap(BasemapStyle.ARCGIS_IMAGERY_STANDARD)
                "darkGrayCanvasVector" -> Basemap(BasemapStyle.ARCGIS_DARK_GRAY)
                "imageryWithLabelsVector", "imageryWithLabels" -> Basemap(BasemapStyle.ARCGIS_IMAGERY)
                "lightGrayCanvasVector", "lightGrayCanvas" -> Basemap(BasemapStyle.ARCGIS_LIGHT_GRAY)
                "navigationVector" -> Basemap(BasemapStyle.ARCGIS_NAVIGATION)
                "openStreetMap" -> Basemap(BasemapStyle.OSM_STANDARD)
                "streetsNightVector" -> Basemap(BasemapStyle.ARCGIS_STREETS_NIGHT)
                "streetsWithReliefVector" -> Basemap(BasemapStyle.ARCGIS_STREETS_RELIEF)
                "terrainWithLabelsVector", "terrainWithLabels" -> Basemap(BasemapStyle.ARCGIS_TERRAIN)
                "oceans" -> Basemap(BasemapStyle.ARCGIS_OCEANS)
                "nationalGeographic" -> Basemap.createNationalGeographic()
                else -> throw IllegalStateException("Unexpected value: $type")
            }
        }

        private fun getBasemapType(basemapType: String?): Basemap.Type {
            return when (basemapType) {
                "imagery" -> Basemap.Type.IMAGERY
                "imageryWithLabels" -> Basemap.Type.IMAGERY_WITH_LABELS
                "streets" -> Basemap.Type.STREETS
                "topographic" -> Basemap.Type.TOPOGRAPHIC
                "terrainWithLabels" -> Basemap.Type.TERRAIN_WITH_LABELS
                "lightGrayCanvas" -> Basemap.Type.LIGHT_GRAY_CANVAS
                "nationalGeographic" -> Basemap.Type.NATIONAL_GEOGRAPHIC
                "oceans" -> Basemap.Type.OCEANS
                "openStreetMap" -> Basemap.Type.OPEN_STREET_MAP
                "imageryWithLabelsVector" -> Basemap.Type.IMAGERY_WITH_LABELS_VECTOR
                "streetsVector" -> Basemap.Type.STREETS_VECTOR
                "topographicVector" -> Basemap.Type.TOPOGRAPHIC_VECTOR
                "terrainWithLabelsVector" -> Basemap.Type.TERRAIN_WITH_LABELS_VECTOR
                "lightGrayCanvasVector" -> Basemap.Type.LIGHT_GRAY_CANVAS_VECTOR
                "navigationVector" -> Basemap.Type.NAVIGATION_VECTOR
                "streetsNightVector" -> Basemap.Type.STREETS_NIGHT_VECTOR
                "streetsWithReliefVector" -> Basemap.Type.STREETS_WITH_RELIEF_VECTOR
                "darkGrayCanvasVector" -> Basemap.Type.DARK_GRAY_CANVAS_VECTOR
                else -> throw IllegalStateException("Unexpected value: $basemapType")
            }
        }

        private fun toElevationSourceList(list: List<*>?): List<ElevationSource?> {
            val elevationSources = ArrayList<ElevationSource?>()
            for (o in list!!) {
                elevationSources.add(o?.let { toElevationSource(it) })
            }
            return elevationSources
        }

        private fun toElevationSource(o: Any): ElevationSource {
            val map = toMap(o)
            if ("ArcGISTiledElevationSource" == map["elevationType"].toString()) {
                return ArcGISTiledElevationSource(map["url"] as String?)
            }
            throw IllegalStateException("Unexpected value: " + map["elevationType"].toString())
        }

        protected fun toFlutterFieldType(o: Any?): Any {
            var o = o
            val data: MutableMap<String, Any?> = HashMap(2)
            val fieldTypeFlutter: FieldTypeFlutter
            if (o is String) {
                fieldTypeFlutter = FieldTypeFlutter.TEXT
            } else if (o is Short || o is Int) {
                fieldTypeFlutter = FieldTypeFlutter.INTEGER
            } else if (o is Float || o is Double) {
                fieldTypeFlutter = FieldTypeFlutter.DOUBLE
            } else if (o is GregorianCalendar) {
                fieldTypeFlutter = FieldTypeFlutter.DATE
                o = ISO8601Format.format(
                    o.time
                )
            } else if (o is UUID) {
                fieldTypeFlutter = FieldTypeFlutter.TEXT
                o = o.toString()
            } else if (o is ByteArray || o is ByteBuffer) {
                fieldTypeFlutter = FieldTypeFlutter.BLOB
                if (o is ByteBuffer) {
                    o = o.array()
                }
            } else if (o is Geometry) {
                fieldTypeFlutter = FieldTypeFlutter.GEOMETRY
                if (o != null) {
                    o = geometryToJson(o as Geometry?)
                }
            } else if (o == null) {
                fieldTypeFlutter = FieldTypeFlutter.NULLABLE
            } else {
                fieldTypeFlutter = FieldTypeFlutter.UNKNOWN
                o = o.toString()
            }
            data["type"] = fieldTypeFlutter.value
            data["value"] = o
            return data
        }

        protected fun fromFlutterField(o: Any?): Any? {
            val data = toMap(
                o!!
            )
            val fieldTypeFlutter = FieldTypeFlutter.values()[toInt(
                data["type"]
            )]
            var value = data["value"]
            when (fieldTypeFlutter) {
                FieldTypeFlutter.DATE -> try {
                    value = ISO8601Format.parse(value.toString())
                } catch (e: Exception) {
                    // no op
                }

                FieldTypeFlutter.GEOMETRY -> if (value != null) {
                    value = toGeometry(value)
                }

                else -> {}
            }
            return value
        }

        fun toBoolean(o: Any): Boolean {
            return o as Boolean
        }

        fun toMap(o: Any): Map<*, *> {
            return o as Map<*, *>
        }

        fun toList(o: Any): List<*> {
            return o as List<*>
        }

        fun toDoubleArray(o: Any?): DoubleArray? {
            return if (o is List<*>) {
                (o as List<Double>).stream().mapToDouble { obj: Double -> obj }
                    .toArray()
            } else o as DoubleArray?
        }

        fun toIntArray(o: Any): IntArray {
            return if (o is List<*>) {
                (o as List<Int>).stream().mapToInt { obj: Int -> obj }.toArray()
            } else o as IntArray
        }

        fun toDouble(o: Any?): Double {
            return (o as Number?)!!.toDouble()
        }

        fun toFloat(o: Any?): Float {
            return (o as Number?)!!.toFloat()
        }

        fun toInt(o: Any?): Int {
            return (o as Number?)!!.toInt()
        }

        fun toLong(o: Any?): Long {
            return (o as Number?)!!.toLong()
        }

        fun toCalendarFromISO8601(o: Any?): Calendar? {
            val dateStr = o as String?
            return if (dateStr.isNullOrEmpty()) {
                null
            } else try {
                val date = ISO8601Format.parse(dateStr)
                val calendar = Calendar.getInstance()
                calendar.time = date
                calendar
            } catch (ex: Exception) {
                Log.e(TAG, "toCalendarFromISO8601: failed to parse iso8601 - $dateStr", ex)
                null
            }
        }

        fun dpToPixelsI(context: Context, dp: Int): Int {
            return (dp * (context.resources.displayMetrics.densityDpi.toFloat() / DisplayMetrics.DENSITY_DEFAULT)).toInt()
        }

        fun dpToPixelsF(context: Context, dp: Float): Float {
            return dp * (context.resources.displayMetrics.densityDpi.toFloat() / DisplayMetrics.DENSITY_DEFAULT)
        }

        fun pixelsToDpI(context: Context, pixels: Float): Int {
            return (pixels / (context.resources.displayMetrics.densityDpi.toFloat() / DisplayMetrics.DENSITY_DEFAULT)).toInt()
        }

        fun pixelsToDpF(context: Context, pixels: Float): Float {
            return pixels / (context.resources.displayMetrics.densityDpi.toFloat() / DisplayMetrics.DENSITY_DEFAULT)
        }

        fun spToPixels(context: Context, sp: Int): Int {
            return TypedValue.applyDimension(
                TypedValue.COMPLEX_UNIT_SP,
                sp.toFloat(),
                context.resources.displayMetrics
            ).toInt()
        }

        private fun attachLoadableLogger(tag: String, loadable: Loadable) {
            if (!BuildConfig.DEBUG) {
                return
            }
            val logger = LoadStatusChangedListenerLogger(tag, loadable)
            logger.attach()
        }
    }
}