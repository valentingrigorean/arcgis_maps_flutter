package com.valentingrigorean.arcgis_maps_flutter.map

import java.util.Objects

class SymbolVisibilityFilter(val minZoom: Double, val maxZoom: Double) {

    override fun equals(o: Any?): Boolean {
        if (this === o) return true
        if (o == null || javaClass != o.javaClass) return false
        val that = o as SymbolVisibilityFilter
        return java.lang.Double.compare(
            that.minZoom,
            minZoom
        ) == 0 && java.lang.Double.compare(that.maxZoom, maxZoom) == 0
    }

    override fun hashCode(): Int {
        return Objects.hash(minZoom, maxZoom)
    }
}