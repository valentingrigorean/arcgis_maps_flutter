package com.valentingrigorean.arcgis_maps_flutter.geometry

import android.util.Log
import com.arcgismaps.geometry.AngularUnit
import com.arcgismaps.geometry.AreaUnit
import com.arcgismaps.geometry.GeometryEngine
import com.arcgismaps.geometry.LinearUnit
import com.arcgismaps.geometry.Point
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.*
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class GeometryEngineController(messenger: BinaryMessenger) : MethodCallHandler {
    private val channel: MethodChannel

    init {
        channel = MethodChannel(messenger, "plugins.flutter.io/arcgis_channel/geometry_engine")
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
                handleDistanceGeodetic(call.arguments()!!, result)
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
                val params = call.arguments.toGeodesicSectorParametersOrNull()!!
                val geometry = GeometryEngine.sectorGeodesicOrNull(params)
                result.success(geometry?.toFlutterJson())
            }

            "geodeticMove" -> {
                handleGeodeticMove(call.arguments()!!, result)
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
                handleAreaGeodetic(call.arguments()!!, result)
            }

            "getExtent" -> {
                handleGetExtent(call.arguments()!!, result)
            }

            else -> result.notImplemented()
        }
    }

    private fun handleProject(data: Map<*, *>, result: MethodChannel.Result) {
        val spatialReference = data["spatialReference"]?.toSpatialReferenceOrNull()!!
        val geometry = data["geometry"]?.toGeometryOrNull()!!
        val projectedGeometry = GeometryEngine.projectOrNull(geometry, spatialReference)
        result.success(projectedGeometry?.toFlutterJson())
    }

    private fun handleDistanceGeodetic(data: Map<*, *>, result: MethodChannel.Result) {
        val point1 = data["point1"]?.toGeometryOrNull() as Point
        val point2 = data["point2"]?.toGeometryOrNull() as Point
        val distanceUnitId = (data["distanceUnitId"] as Int).toLinearUnitId()
        val azimuthUnitId = (data["azimuthUnitId"] as Int).toAngularUnitId()
        val curveType = (data["curveType"] as Int).toGeodeticCurveType()
        try {
            val geodeticDistanceResult = GeometryEngine.distanceGeodeticOrNull(
                point1,
                point2,
                LinearUnit(distanceUnitId),
                AngularUnit(azimuthUnitId),
                curveType
            )
            result.success(geodeticDistanceResult?.toFlutterJson())
        } catch (ex: Exception) {
            Log.e(TAG, "Failed to get distanceGeodetic ", ex)
            result.success(null)
        }
    }

    private fun handleBufferGeometry(data: Map<*, *>, result: MethodChannel.Result) {
        val geometry = data["geometry"]?.toGeometryOrNull()!!
        val distance = data["distance"] as Double
        val polygon = GeometryEngine.bufferOrNull(geometry, distance)
        result.success(polygon?.toFlutterJson())
    }

    private fun handleGeodeticBufferGeometry(data: Map<*, *>, result: MethodChannel.Result) {
        val geometry = data["geometry"]?.toGeometryOrNull()!!
        val distance = data["distance"] as Double
        val distanceUnitId = (data["distanceUnit"] as Int).toLinearUnitId()
        val maxDeviation = data["maxDeviation"] as Double
        val curveType = (data["curveType"] as Int).toGeodeticCurveType()
        val polygon = GeometryEngine.bufferGeodeticOrNull(
            geometry,
            distance,
            LinearUnit(distanceUnitId),
            maxDeviation,
            curveType
        )
        result.success(polygon?.toFlutterJson())
    }

    private fun handleIntersection(data: Map<*, *>, result: MethodChannel.Result) {
        val firstGeometry = data["firstGeometry"]?.toGeometryOrNull()!!
        val secondGeometry = data["secondGeometry"]?.toGeometryOrNull()!!
        val geometry = GeometryEngine.intersectionOrNull(firstGeometry, secondGeometry)
        result.success(geometry?.toFlutterJson())
    }

    private fun handleGeodeticMove(data: Map<*, *>, result: MethodChannel.Result) {
        val points = (data["points"] as List<*>).map { it?.toPointOrNull()!! }
        val distance = data["distance"] as Double
        val distanceUnitId = (data["distanceUnit"] as Int).toLinearUnitId()
        val azimuth = data["azimuth"] as Double
        val azimuthUnitId = (data["azimuthUnit"] as Int).toAngularUnitId()
        val curveType = (data["curveType"] as Int).toGeodeticCurveType()
        val movedPoints = GeometryEngine.tryMoveGeodetic(
            points,
            distance,
            LinearUnit(distanceUnitId),
            azimuth,
            AngularUnit(azimuthUnitId),
            curveType
        )
        result.success(movedPoints.map { it.toFlutterJson() })
    }

    private fun handleSimply(data: Map<*, *>, result: MethodChannel.Result) {
        val originGeometry = data?.toGeometryOrNull()!!
        val simplifiedGeometry = GeometryEngine.simplifyOrNull(originGeometry)
        result.success(simplifiedGeometry?.toFlutterJson())
    }

    private fun handleIntersections(data: Map<*, *>, result: MethodChannel.Result) {
        val firstGeometry = data["firstGeometry"]?.toGeometryOrNull()!!
        val secondGeometry = data["secondGeometry"]?.toGeometryOrNull()!!
        val geometryList = GeometryEngine.tryIntersections(firstGeometry, secondGeometry)
        result.success(geometryList.map { it.toFlutterJson() })
    }


    private fun handleIsSimple(data: Map<*, *>, result: MethodChannel.Result) {
        val originGeometry = data?.toGeometryOrNull()!!
        result.success(GeometryEngine.isSimple(originGeometry))
    }

    private fun handleDensifyGeodetic(data: Map<*, *>, result: MethodChannel.Result) {
        val geometry = data["geometry"]?.toGeometryOrNull()!!
        val maxSegmentLength = data["maxSegmentLength"] as Double
        val linearUnitId = (data["lengthUnit"] as Int).toLinearUnitId()
        val curveType = (data["curveType"] as Int).toGeodeticCurveType()
        val resultGeometry = GeometryEngine.densifyGeodeticOrNull(
            geometry,
            maxSegmentLength,
            LinearUnit(linearUnitId),
            curveType
        )
        result.success(resultGeometry?.toFlutterJson())
    }

    private fun handleLengthGeodetic(data: Map<*, *>, result: MethodChannel.Result) {
        val geometry = data["geometry"]?.toGeometryOrNull()!!
        val linearUnitId = (data["lengthUnit"] as Int).toLinearUnitId()
        val curveType = (data["curveType"] as Int).toGeodeticCurveType()
        result.success(
            GeometryEngine.lengthGeodetic(
                geometry,
                LinearUnit(linearUnitId),
                curveType
            )
        )
    }

    private fun handleAreaGeodetic(data: Map<*, *>, result: MethodChannel.Result) {
        val geometry = data["geometry"]?.toGeometryOrNull()!!
        val areaUnit = (data["areaUnit"] as Int).toAreaUnitId()
        val curveType = (data["curveType"] as Int).toGeodeticCurveType()
        result.success(GeometryEngine.areaGeodetic(geometry, AreaUnit(areaUnit), curveType))
    }

    private fun handleGetExtent(data: Map<*, *>, result: MethodChannel.Result) {
        val geometry = data["geometry"]?.toGeometryOrNull()!!
        result.success(geometry.extent.toFlutterJson())
    }

    companion object {
        private const val TAG = "GeometryEngineController"
    }
}