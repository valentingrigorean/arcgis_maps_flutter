package com.valentingrigorean.arcgis_maps_flutter.convert.mapping.symbology

import com.arcgismaps.mapping.symbology.SimpleLineSymbol

fun SimpleLineSymbol.interpretSimpleLineSymbol(data: Map<*, *>) {
    this.interpretLineSymbol(data)
    data["style"]?.let {
        style = (it as String).toSimpleLineSymbolStyle()
    }
    data["markerStyle"]?.let {
        markerStyle = (it as String).toSimpleLineSymbolMarkerStyle()
    }
    data["markerPlacement"]?.let {
        markerPlacement = (it as String).toSimpleLineSymbolMarkerPlacement()
    }
}