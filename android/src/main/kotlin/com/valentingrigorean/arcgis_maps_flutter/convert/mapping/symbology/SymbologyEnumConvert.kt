package com.valentingrigorean.arcgis_maps_flutter.convert.mapping.symbology

import com.arcgismaps.mapping.symbology.*

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

fun String.toHorizontalAlignment(): HorizontalAlignment {
    return when (this) {
        "center" -> HorizontalAlignment.Center
        "justify" -> HorizontalAlignment.Justify
        "left" -> HorizontalAlignment.Left
        "right" -> HorizontalAlignment.Right
        else -> throw IllegalArgumentException("Unknown HorizontalAlignment")
    }
}

fun String.toVerticalAlignment(): VerticalAlignment {
    return when (this) {
        "baseline" -> VerticalAlignment.Baseline
        "bottom" -> VerticalAlignment.Bottom
        "middle" -> VerticalAlignment.Middle
        "top" -> VerticalAlignment.Top
        else -> throw IllegalArgumentException("Unknown VerticalAlignment")
    }
}

fun String.toSymbolAngleAlignment(): SymbolAngleAlignment {
    return when (this) {
        "map" -> SymbolAngleAlignment.Map
        "screen" -> SymbolAngleAlignment.Screen
        else -> throw IllegalArgumentException("Unknown SymbolAngleAlignment")
    }
}

fun String.toFontWeight() : FontWeight {
    return when (this) {
        "bold" -> FontWeight.Bold
        "normal" -> FontWeight.Normal
        else -> throw IllegalArgumentException("Unknown FontWeight")
    }
}

fun String.toFontStyle() : FontStyle {
    return when (this) {
        "italic" -> FontStyle.Italic
        "normal" -> FontStyle.Normal
        "oblique" -> FontStyle.Oblique
        else -> throw IllegalArgumentException("Unknown FontStyle")
    }
}