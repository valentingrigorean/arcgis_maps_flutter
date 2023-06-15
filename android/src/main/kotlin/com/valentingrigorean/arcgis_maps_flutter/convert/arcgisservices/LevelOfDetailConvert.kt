package com.valentingrigorean.arcgis_maps_flutter.convert.arcgisservices

import com.arcgismaps.arcgisservices.LevelOfDetail

fun Any.toLevelOfDetailOrNull() : LevelOfDetail?{
    val data = this as? Map<*, *> ?: return null
    val level = data["level"] as Int
    val resolution = data["resolution"] as Double
    val scale = data["scale"] as Double
    return LevelOfDetail(level, resolution, scale)
}