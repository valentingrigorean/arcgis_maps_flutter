package com.valentingrigorean.arcgis_maps_flutter.convert.mapping.symbology

import com.arcgismaps.mapping.symbology.SimpleLineSymbolStyle
import com.arcgismaps.mapping.symbology.SimpleMarkerSymbolStyle

fun Int.toSimpleMarkerSymbolStyle(): SimpleMarkerSymbolStyle {
    return when (this) {
        0 -> SimpleMarkerSymbolStyle.Circle
        1 -> SimpleMarkerSymbolStyle.Cross
        2 -> SimpleMarkerSymbolStyle.Diamond
        3 -> SimpleMarkerSymbolStyle.Square
        4 -> SimpleMarkerSymbolStyle.Triangle
        5 -> SimpleMarkerSymbolStyle.X
        else -> throw IllegalArgumentException("Unknown SimpleLineSymbolStyle")
    }
}

fun Int.toSimpleLineSymbolStyle(): SimpleLineSymbolStyle {
    return when (this) {
        0 -> SimpleLineSymbolStyle.Dash
        1 -> SimpleLineSymbolStyle.DashDot
        2 -> SimpleLineSymbolStyle.DashDotDot
        3 -> SimpleLineSymbolStyle.Dot
        4 -> SimpleLineSymbolStyle.LongDash
        5 -> SimpleLineSymbolStyle.LongDashDot
        6 -> SimpleLineSymbolStyle.Null
        7 -> SimpleLineSymbolStyle.ShortDash
        8 -> SimpleLineSymbolStyle.ShortDashDot
        9 -> SimpleLineSymbolStyle.ShortDashDotDot
        10 -> SimpleLineSymbolStyle.ShortDot
        11 -> SimpleLineSymbolStyle.Solid
        else -> throw IllegalArgumentException("Unknown SimpleLineSymbolStyle")
    }
}