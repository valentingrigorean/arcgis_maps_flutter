package com.valentingrigorean.arcgis_maps_flutter.convert.mapping

import com.arcgismaps.mapping.ArcGISScene

fun Any.toSurfaceOrNull() : ArcGISScene? {
    val data = this as? Map<*, *> ?: return null
    if (data.containsKey("json")) {
        return ArcGISScene.fromJsonOrNull(data["json"] as String)
    }
    val basemap = data["basemap"]?.toBasemapOrNull() ?: return null
    return ArcGISScene(basemap)
}

