package com.valentingrigorean.arcgis_maps_flutter.geometry

import android.util.Log
import com.esri.arcgisruntime.geometry.AngularUnit
import com.esri.arcgisruntime.geometry.AngularUnitId
import com.esri.arcgisruntime.geometry.AreaUnit
import com.esri.arcgisruntime.geometry.AreaUnitId
import com.esri.arcgisruntime.geometry.GeodesicSectorParameters
import com.esri.arcgisruntime.geometry.GeodeticCurveType
import com.esri.arcgisruntime.geometry.Geometry
import com.esri.arcgisruntime.geometry.GeometryEngine
import com.esri.arcgisruntime.geometry.LinearUnit
import com.esri.arcgisruntime.geometry.LinearUnitId
import com.esri.arcgisruntime.geometry.Point
import com.esri.arcgisruntime.geometry.SpatialReference
import com.valentingrigorean.arcgis_maps_flutter.Convert
import com.valentingrigorean.arcgis_maps_flutter.utils.toMap
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class GeometryEngineController(messenger: BinaryMessenger?) : MethodCallHandler {
    private val channel: MethodChannel

    init {
        channel = MethodChannel(messenger!!, "plugins.flutter.io/arcgis_channel/geometry_engine")
        channel.setMethodCallHandler(this)
    }

    fun dispose() {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "project" -> {
                handleProject(call.arguments()!!, result)
            }

            "distanceGeodetic" -> {
                val data: Map<*, *> = Convert.Companion.toMap(call.arguments)
                handleDistanceGeodetic(data, result)
            }

            "bufferGeometry" -> {
                handleBufferGeometry(call.arguments()!!, result)
            }

            "geodeticBufferGeometry" -> {
                handleGeodeticBufferGeometry(call.arguments()!!, result)
            }

            "intersection" -> {
                handleIntersection(call.arguments()!!, result)
            }

            "intersections" -> {
                handleIntersections(call.arguments()!!, result)
            }

            "geodesicSector" -> {
                val params: GeodesicSectorParameters =
                    Convert.Companion.toGeodesicSectorParameters(call.arguments)
                val geometry = GeometryEngine.sectorGeodesic(params)
                result.success(Convert.Companion.geometryToJson(geometry))
            }

            "geodeticMove" -> {
                run { handleGeodeticMove(call.arguments()!!, result) }
                run { handleSimply(call.arguments()!!, result) }
            }

            "simplify" -> {
                handleSimply(call.arguments()!!, result)
            }

            "isSimple" -> {
                handleIsSimple(call.arguments()!!, result)
            }

            "densifyGeodetic" -> {
                handleDensifyGeodetic(call.arguments()!!, result)
            }

            "lengthGeodetic" -> {
                handleLengthGeodetic(call.arguments()!!, result)
            }

            "areaGeodetic" -> {
                run { handleAreaGeodetic(call.arguments()!!, result) }
                run { handleGetExtent(call.arguments()!!, result) }
            }

            "getExtent" -> {
                handleGetExtent(call.arguments()!!, result)
            }

            else -> result.notImplemented()
        }
    }

    private fun handleGeodeticMove(data: Map<*, *>, result: MethodChannel.Result) {
        val rawPoints: List<*> = Convert.Companion.toList(
            data["points"]!!
        )
        val distance: Double = Convert.Companion.toDouble(
            data["distance"]
        )
        val distanceUnitId: LinearUnitId = Convert.Companion.toLinearUnitId(
            data["distanceUnit"]
        )
        val azimuth: Double = Convert.Companion.toDouble(
            data["azimuth"]
        )
        val azimuthUnitId: AngularUnitId = Convert.Companion.toAngularUnitId(
            data["azimuthUnit"]
        )
        val curveType: GeodeticCurveType = Convert.Companion.toGeodeticCurveType(
            data["curveType"]
        )
        val points: MutableList<Point> = ArrayList()
        for (rawPoint in rawPoints) {
            points.add(Convert.Companion.toPoint(rawPoint))
        }
        val movedPoints = GeometryEngine.moveGeodetic(
            points,
            distance,
            LinearUnit(distanceUnitId),
            azimuth,
            AngularUnit(azimuthUnitId),
            curveType
        )
        val resultPoints: MutableList<Any?> = ArrayList()
        for (point in movedPoints) {
            resultPoints.add(Convert.Companion.geometryToJson(point))
        }
        result.success(resultPoints)
    }

    private fun handleIntersections(data: Map<*, *>, result: MethodChannel.Result) {
        val firstGeometry: Geometry = Convert.Companion.toGeometry(
            data["firstGeometry"]
        )
        val secondGeometry: Geometry = Convert.Companion.toGeometry(
            data["secondGeometry"]
        )
        val geometryList = GeometryEngine.intersections(firstGeometry, secondGeometry)
        val resultList = ArrayList<Any?>()
        for (geometry in geometryList) {
            resultList.add(Convert.Companion.geometryToJson(geometry))
        }
        result.success(resultList)
    }

    private fun handleIntersection(data: Map<*, *>, result: MethodChannel.Result) {
        val firstGeometry: Geometry = Convert.Companion.toGeometry(
            data["firstGeometry"]
        )
        val secondGeometry: Geometry = Convert.Companion.toGeometry(
            data["secondGeometry"]
        )
        val geometry = GeometryEngine.intersection(firstGeometry, secondGeometry)
        result.success(Convert.Companion.geometryToJson(geometry))
    }

    private fun handleGeodeticBufferGeometry(data: Map<*, *>, result: MethodChannel.Result) {
        val geometry: Geometry = Convert.Companion.toGeometry(
            data["geometry"]
        )
        val distance: Double = Convert.Companion.toDouble(
            data["distance"]
        )
        val distanceUnitId: LinearUnitId = Convert.Companion.toLinearUnitId(
            data["distanceUnit"]
        )
        val maxDeviation: Double = Convert.Companion.toDouble(
            data["maxDeviation"]
        )
        val curveType: GeodeticCurveType = Convert.Companion.toGeodeticCurveType(
            data["curveType"]
        )
        val polygon = GeometryEngine.bufferGeodetic(
            geometry,
            distance,
            LinearUnit(distanceUnitId),
            maxDeviation,
            curveType
        )
        if (polygon == null) {
            result.success(null)
        } else {
            result.success(Convert.Companion.geometryToJson(polygon))
        }
    }

    private fun handleBufferGeometry(data: Map<*, *>, result: MethodChannel.Result) {
        val geometry: Geometry = Convert.Companion.toGeometry(
            data["geometry"]
        )
        val distance: Double = Convert.Companion.toDouble(
            data["distance"]
        )
        val polygon = GeometryEngine.buffer(geometry, distance)
        if (polygon == null) {
            result.success(null)
        } else {
            result.success(Convert.Companion.geometryToJson(polygon))
        }
    }

    private fun handleProject(data: Map<*, *>, result: MethodChannel.Result) {
        val spatialReference: SpatialReference = Convert.Companion.toSpatialReference(
            data["spatialReference"]
        )
        val geometry: Geometry = Convert.Companion.toGeometry(
            data["geometry"]
        )
        val projectedGeometry = GeometryEngine.project(geometry, spatialReference)
        if (projectedGeometry == null) {
            result.success(null)
        } else {
            result.success(Convert.Companion.geometryToJson(projectedGeometry))
        }
    }

    private fun handleDistanceGeodetic(data: Map<*, *>, result: MethodChannel.Result) {
        val point1 = Convert.Companion.toGeometry(data["point1"]) as Point
        val point2 = Convert.Companion.toGeometry(data["point2"]) as Point
        val distanceUnitId: LinearUnitId = Convert.Companion.toLinearUnitId(
            data["distanceUnitId"]
        )
        val azimuthUnitId: AngularUnitId = Convert.Companion.toAngularUnitId(
            data["azimuthUnitId"]
        )
        val curveType: GeodeticCurveType = Convert.Companion.toGeodeticCurveType(
            data["curveType"]
        )
        try {
            val geodeticDistanceResult = GeometryEngine.distanceGeodetic(
                point1,
                point2,
                LinearUnit(distanceUnitId),
                AngularUnit(azimuthUnitId),
                curveType
            )
            if (geodeticDistanceResult == null) {
                result.success(null)
                return
            }
            val json: MutableMap<String, Any?> = HashMap(4)
            json["distance"] = geodeticDistanceResult.distance
            json["distanceUnitId"] = data["distanceUnitId"]
            json["azimuth1"] = geodeticDistanceResult.azimuth1
            json["azimuth2"] = geodeticDistanceResult.azimuth2
            json["angularUnitId"] = data["azimuthUnitId"]
            result.success(json)
        } catch (ex: Exception) {
            Log.e(TAG, "Failed to get distanceGeodetic ", ex)
            result.success(null)
        }
    }

    private fun handleSimply(data: Map<*, *>, result: MethodChannel.Result) {
        val originGeometry: Geometry = Convert.Companion.toGeometry(data)
        if (originGeometry == null) {
            Log.e(TAG, "Failed to simply as geometry is null")
            result.success(null)
        } else {
            val simplifiedGeometry = GeometryEngine.simplify(originGeometry)
            result.success(Convert.Companion.geometryToJson(simplifiedGeometry))
        }
    }

    private fun handleIsSimple(data: Map<*, *>, result: MethodChannel.Result) {
        val originGeometry: Geometry = Convert.Companion.toGeometry(data)
        if (originGeometry == null) {
            Log.e(TAG, "Failed to get isSimple as geometry is null")
            result.success(true)
        } else {
            result.success(GeometryEngine.isSimple(originGeometry))
        }
    }

    private fun handleDensifyGeodetic(data: Map<*, *>, result: MethodChannel.Result) {
        val geometry: Geometry = Convert.Companion.toGeometry(
            data["geometry"]
        )
        val maxSegmentLength: Double = Convert.Companion.toDouble(
            data["maxSegmentLength"]
        )
        val lengthUnit: LinearUnitId = Convert.Companion.toLinearUnitId(
            data["lengthUnit"]
        )
        val curveType: GeodeticCurveType = Convert.Companion.toGeodeticCurveType(
            data["curveType"]
        )
        if (geometry == null) {
            Log.e(TAG, "Failed to get isSimple as geometry is null")
            result.success(null)
        } else {
            val resultGeometry = GeometryEngine.densifyGeodetic(
                geometry,
                maxSegmentLength,
                LinearUnit(lengthUnit),
                curveType
            )
            result.success(Convert.Companion.geometryToJson(resultGeometry))
        }
    }

    private fun handleLengthGeodetic(data: Map<*, *>, result: MethodChannel.Result) {
        val geometry: Geometry = Convert.Companion.toGeometry(
            data["geometry"]
        )
        val lengthUnit: LinearUnitId = Convert.Companion.toLinearUnitId(
            data["lengthUnit"]
        )
        val curveType: GeodeticCurveType = Convert.Companion.toGeodeticCurveType(
            data["curveType"]
        )
        if (geometry == null) {
            Log.e(TAG, "Failed to get lengthGeodetic as geometry is null")
            result.success(null)
        } else {
            result.success(
                GeometryEngine.lengthGeodetic(
                    geometry,
                    LinearUnit(lengthUnit),
                    curveType
                )
            )
        }
    }

    private fun handleAreaGeodetic(data: Map<*, *>, result: MethodChannel.Result) {
        val geometry: Geometry = Convert.Companion.toGeometry(
            data["geometry"]
        )
        val areaUnit: AreaUnitId = Convert.Companion.toAreaUnitId(
            data["areaUnit"]
        )
        val curveType: GeodeticCurveType = Convert.Companion.toGeodeticCurveType(
            data["curveType"]
        )
        if (geometry == null) {
            Log.e(TAG, "Failed to get areaGeodetic as geometry is null")
            result.success(null)
        } else {
            result.success(GeometryEngine.areaGeodetic(geometry, AreaUnit(areaUnit), curveType))
        }
    }

    private fun handleGetExtent(data: Map<*, *>, result: MethodChannel.Result) {
        val geometry: Geometry = Convert.Companion.toGeometry(
            data["geometry"]
        )
        if (geometry == null) {
            Log.e(TAG, "Failed to get extent as geometry is null")
            result.success(null)
        } else {
            result.success(Convert.Companion.geometryToJson(geometry.extent))
        }
    }

    companion object {
        private const val TAG = "GeometryEngineController"
    }
}