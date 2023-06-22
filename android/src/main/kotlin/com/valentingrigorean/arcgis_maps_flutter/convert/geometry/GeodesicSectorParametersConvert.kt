package com.valentingrigorean.arcgis_maps_flutter.convert.geometry

import com.arcgismaps.geometry.AngularUnit
import com.arcgismaps.geometry.GeodesicSectorParameters
import com.arcgismaps.geometry.GeometryType
import com.arcgismaps.geometry.LinearUnit
import com.arcgismaps.geometry.Point
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterLong

fun Any.toGeodesicSectorParametersOrNull(): GeodesicSectorParameters? {
    val data = this as? Map<*, *> ?: return null
    val geometryType = (data["geometryType"] as Int).toGeometryType()
    val geodesicSectorParameters = createGeodesicSectorParameters(geometryType)
    geodesicSectorParameters.center = data["center"]?.toGeometryOrNull() as Point?
    geodesicSectorParameters.semiAxis1Length = data["semiAxis1Length"] as Double
    geodesicSectorParameters.semiAxis2Length = data["semiAxis2Length"] as Double
    geodesicSectorParameters.startDirection = data["startDirection"] as Double
    geodesicSectorParameters.sectorAngle = data["sectorAngle"] as Double
    geodesicSectorParameters.linearUnit = LinearUnit(
        (data["linearUnit"] as Int).toLinearUnitId()
    )
    geodesicSectorParameters.angularUnit = AngularUnit(
        (data["angularUnit"] as Int).toAngularUnitId()
    )
    geodesicSectorParameters.axisDirection = data["axisDirection"] as Double
    val maxSegmentLength = data["maxSegmentLength"] as Double?
    if (maxSegmentLength != null) {
        geodesicSectorParameters.maxSegmentLength = maxSegmentLength
    }
    geodesicSectorParameters.maxPointCount = data["maxPointCount"]!!.toFlutterLong()
    return geodesicSectorParameters
}


private fun createGeodesicSectorParameters(geometryType: GeometryType): GeodesicSectorParameters {
    return when (geometryType) {
        GeometryType.Polyline -> GeodesicSectorParameters.createForPolyline()
        GeometryType.Polygon -> GeodesicSectorParameters.createForPolygon()
        GeometryType.Multipoint -> GeodesicSectorParameters.createForMultipoint()
        else -> throw IllegalArgumentException("GeometryType not supported")
    }
}

