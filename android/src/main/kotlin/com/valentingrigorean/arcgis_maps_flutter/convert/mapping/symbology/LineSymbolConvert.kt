package com.valentingrigorean.arcgis_maps_flutter.convert.mapping.symbology

import com.arcgismaps.mapping.symbology.LineSymbol
import com.valentingrigorean.arcgis_maps_flutter.convert.toArcgisColorOrNull

fun LineSymbol.interpretLineSymbol(data: Map<*, *>) {
    data["antiAlias"]?.let {
        antiAlias = it as Boolean
    }
    data["color"]?.let {
        color = it.toArcgisColorOrNull()!!
    }
    data["width"]?.let {
        width = (it as Double).toFloat()
    }
}