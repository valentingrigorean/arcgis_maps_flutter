package com.valentingrigorean.arcgis_maps_flutter.convert.map

import com.valentingrigorean.arcgis_maps_flutter.map.SymbolVisibilityFilter

fun Any.toSymbolVisibilityFilterOrNull() : SymbolVisibilityFilter?{
    val map = this as? Map<*,*> ?: return null
    val minZoom = map["minZoom"] as? Double ?: return null
    val maxZoom = map["maxZoom"] as? Double ?: return null
    return SymbolVisibilityFilter(minZoom, maxZoom)
}