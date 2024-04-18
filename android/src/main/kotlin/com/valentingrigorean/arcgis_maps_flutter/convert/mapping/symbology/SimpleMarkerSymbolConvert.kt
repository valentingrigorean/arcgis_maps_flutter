package com.valentingrigorean.arcgis_maps_flutter.convert.mapping.symbology

import com.arcgismaps.mapping.symbology.SimpleMarkerSymbol
import com.valentingrigorean.arcgis_maps_flutter.convert.toArcgisColorOrNull

fun SimpleMarkerSymbol.interpretSimpleMarkerSymbol(data: Map<*, *>) {
    interpretMarkerSymbol(data)
    data["style"]?.let {
        style = (it as String).toSimpleMarkerSymbolStyle()
    }
    data["color"]?.let {
        color = it.toArcgisColorOrNull()!!
    }
    data["size"]?.let {
        size = (it as Double).toFloat()
    }
}