package com.valentingrigorean.arcgis_maps_flutter.convert.mapping.layers

import com.arcgismaps.mapping.layers.TileInfo
import com.valentingrigorean.arcgis_maps_flutter.convert.arcgisservices.toLevelOfDetailOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toPointOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toSpatialReferenceOrNull

fun Any.toTileInfoOrNull(): TileInfo? {
    val data = this as? Map<*, *> ?: return null
    val dpi = data["dpi"] as Int
    val format = (data["format"] as Int).toTileImageFormat()
    val levelOfDetails = (data["levelOfDetails"] as List<*>).map { it!!.toLevelOfDetailOrNull()!! }
    val origin = data["origin"]?.toPointOrNull()!!
    val spatialReference = data["spatialReference"]?.toSpatialReferenceOrNull()!!
    val tileHeight = data["tileHeight"] as Int
    val tileWidth = data["tileWidth"] as Int
    return TileInfo(dpi, format, levelOfDetails, origin, spatialReference, tileHeight, tileWidth)
}