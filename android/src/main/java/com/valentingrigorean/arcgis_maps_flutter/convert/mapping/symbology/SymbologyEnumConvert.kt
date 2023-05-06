package com.valentingrigorean.arcgis_maps_flutter.convert.mapping.symbology

import com.arcgismaps.mapping.symbology.SimpleMarkerSymbolStyle

fun Int.toSimpleMarkerSymbolStyle() {
    when (this) {
        0 -> SimpleMarkerSymbolStyle.Circle
        1 -> SimpleMarkerSymbolStyle.Cross
        2 -> SimpleMarkerSymbolStyle.Diamond
        3 -> SimpleMarkerSymbolStyle.Square
        4 -> SimpleMarkerSymbolStyle.Triangle
        5 -> SimpleMarkerSymbolStyle.X
    }
}