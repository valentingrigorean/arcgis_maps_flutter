package com.valentingrigorean.arcgis_maps_flutter.convert.mapping.symbology

import com.arcgismaps.mapping.symbology.SimpleFillSymbol
import com.arcgismaps.mapping.symbology.SimpleLineSymbol
import com.valentingrigorean.arcgis_maps_flutter.convert.toArcgisColorOrNull

fun SimpleFillSymbol.interpretSimpleFillSymbol(data: Map<*, *>) {
    data["color"]?.let {
        color = it.toArcgisColorOrNull()!!
    }

    data["outline"]?.let {
        outline = SimpleLineSymbol().apply {
            interpretSimpleLineSymbol(it as Map<*, *>)
        }
    }

}