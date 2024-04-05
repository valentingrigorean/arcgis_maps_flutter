package com.valentingrigorean.arcgis_maps_flutter.convert.mapping.symbology

import com.arcgismaps.mapping.symbology.TextSymbol
import com.valentingrigorean.arcgis_maps_flutter.convert.toArcgisColorOrNull

fun TextSymbol.interpretTextSymbol(data: Map<*, *>) {
    interpretMarkerSymbol(data)
    data["text"]?.let {
        text = it as String
    }
    data["size"]?.let {
        size = (it as Double).toFloat()
    }
    data["color"]?.let {
        color = it.toArcgisColorOrNull()!!
    }
    data["fontFamily"]?.let {
        fontFamily = it as String
    }
    data["fontStyle"]?.let {
        fontStyle = (it as String).toFontStyle()
    }
    data["fontWeight"]?.let {
        fontWeight = (it as String).toFontWeight()
    }
    data["haloColor"]?.let {
        haloColor = it.toArcgisColorOrNull()!!
    }
    data["haloWidth"]?.let {
        haloWidth = (it as Double).toFloat()
    }
    data["kerning"]?.let {
        kerningEnabled = it as Boolean
    }

    data["outlineColor"]?.let {
        outlineColor = it.toArcgisColorOrNull()!!
    }
    data["horizontalAlignment"]?.let {
        horizontalAlignment = (it as String).toHorizontalAlignment()
    }
    data["verticalAlignment"]?.let {
        verticalAlignment = (it as String).toVerticalAlignment()
    }
}