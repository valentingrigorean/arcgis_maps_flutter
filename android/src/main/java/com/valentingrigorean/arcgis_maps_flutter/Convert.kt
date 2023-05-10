package com.valentingrigorean.arcgis_maps_flutter

import android.content.Context
import android.graphics.Point
import android.util.DisplayMetrics
import android.util.TypedValue
import com.valentingrigorean.arcgis_maps_flutter.layers.FlutterLayer.ServiceImageTiledLayerOptions
import com.valentingrigorean.arcgis_maps_flutter.map.ScreenLocationData
import java.util.Objects
import java.util.stream.Collectors

open class Convert {
    companion object {
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


        fun toViewPoint(o: Any): Viewpoint {
            val data = toMap(o)
            val scale = toDouble(Objects.requireNonNull(data)["scale"])
            val targetGeometry = toPoint(
                data["targetGeometry"]
            )
            return Viewpoint(targetGeometry, scale)
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
    }
}