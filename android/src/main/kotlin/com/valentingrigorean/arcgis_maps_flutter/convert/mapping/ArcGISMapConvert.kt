package com.valentingrigorean.arcgis_maps_flutter.convert.mapping

import com.arcgismaps.mapping.ArcGISMap
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toSpatialReferenceOrNull

fun Any.toArcGISMapOrNull(): ArcGISMap? {
    val data = this as Map<*, *>? ?: return null
    val baseMap = data["basemap"]?.toBasemapOrNull()
    if (baseMap != null) {
        return ArcGISMap(baseMap)
    }
    val basemapStyle = (data["basemapStyle"] as Int?)?.toBasemapStyle()
    if (basemapStyle != null) {
        return ArcGISMap(basemapStyle)
    }
    val item = data["item"]?.toPortalItemOrNull()
    if (item != null) {
        return ArcGISMap(item)
    }
    val spatialReference = data["spatialReference"]?.toSpatialReferenceOrNull()
    if (spatialReference != null) {
        return ArcGISMap(spatialReference)
    }
    val uri = data["uri"] as String?
    if (uri != null) {
        return ArcGISMap(uri)
    }
    return null
}