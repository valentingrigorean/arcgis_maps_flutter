package com.valentingrigorean.arcgis_maps_flutter.map

import com.arcgismaps.geometry.SpatialReference
import com.arcgismaps.mapping.view.ScreenCoordinate
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toSpatialReferenceOrNull

class ScreenLocationData(val point: ScreenCoordinate, val spatialReference: SpatialReference?) {
    companion object {
        fun fromJson(data: Map<*, *>): ScreenLocationData {
            val points = data["position"] as List<Double>
            val spatialReference = data["spatialReference"]?.toSpatialReferenceOrNull()
            return ScreenLocationData(ScreenCoordinate(points[0], points[1]), spatialReference)
        }
    }
}