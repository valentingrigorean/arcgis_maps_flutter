package com.valentingrigorean.arcgis_maps_flutter.convert.mapping.symbology

import com.arcgismaps.mapping.symbology.*

fun String.toSimpleFillSymbolStyle(): SimpleFillSymbolStyle{
    return when (this) {
        "backwardDiagonal" -> SimpleFillSymbolStyle.BackwardDiagonal
        "cross" -> SimpleFillSymbolStyle.Cross
        "diagonalCross" -> SimpleFillSymbolStyle.DiagonalCross
        "forwardDiagonal" -> SimpleFillSymbolStyle.ForwardDiagonal
        "horizontal" -> SimpleFillSymbolStyle.Horizontal
        "none" -> SimpleFillSymbolStyle.Null
        "solid" -> SimpleFillSymbolStyle.Solid
        "vertical" -> SimpleFillSymbolStyle.Vertical
        else -> throw IllegalArgumentException("Unknown SimpleFillSymbolStyle")
    }

}

fun String.toSimpleMarkerSymbolStyle(): SimpleMarkerSymbolStyle {
    return when (this) {
        "circle" -> SimpleMarkerSymbolStyle.Circle
        "cross" -> SimpleMarkerSymbolStyle.Cross
        "diamond" -> SimpleMarkerSymbolStyle.Diamond
        "square" -> SimpleMarkerSymbolStyle.Square
        "triangle" -> SimpleMarkerSymbolStyle.Triangle
        "x" -> SimpleMarkerSymbolStyle.X
        else -> throw IllegalArgumentException("Unknown SimpleLineSymbolStyle")
    }
}


fun String.toSimpleLineSymbolStyle(): SimpleLineSymbolStyle {
    return when (this) {
        "dash" -> SimpleLineSymbolStyle.Dash
        "dashDot" -> SimpleLineSymbolStyle.DashDot
        "dashDotDot" -> SimpleLineSymbolStyle.DashDotDot
        "dot" -> SimpleLineSymbolStyle.Dot
        "longDash" -> SimpleLineSymbolStyle.LongDash
        "longDashDot" -> SimpleLineSymbolStyle.LongDashDot
        "none" -> SimpleLineSymbolStyle.Null
        "shortDash" -> SimpleLineSymbolStyle.ShortDash
        "shortDashDotDot" -> SimpleLineSymbolStyle.ShortDashDot
        "shortDashDot" -> SimpleLineSymbolStyle.ShortDashDotDot
        "shortDot" -> SimpleLineSymbolStyle.ShortDot
        "solid" -> SimpleLineSymbolStyle.Solid
        else -> throw IllegalArgumentException("Unknown SimpleLineSymbolStyle")
    }
}

fun String.toSimpleLineSymbolMarkerStyle(): SimpleLineSymbolMarkerStyle {
    return when (this) {
        "none" -> SimpleLineSymbolMarkerStyle.None
        "arrow" -> SimpleLineSymbolMarkerStyle.Arrow
        else -> throw IllegalArgumentException("Unknown SimpleLineSymbolMarkerStyle")
    }
}

fun String.toSimpleLineSymbolMarkerPlacement(): SimpleLineSymbolMarkerPlacement {
    return when (this) {
        "begin" -> SimpleLineSymbolMarkerPlacement.Begin
        "beginAndEnd" -> SimpleLineSymbolMarkerPlacement.BeginAndEnd
        "end" -> SimpleLineSymbolMarkerPlacement.End
        else -> throw IllegalArgumentException("Unknown SimpleLineSymbolMarkerPlacement")
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

fun String.toFontWeight(): FontWeight {
    return when (this) {
        "bold" -> FontWeight.Bold
        "normal" -> FontWeight.Normal
        else -> throw IllegalArgumentException("Unknown FontWeight")
    }
}

fun String.toFontStyle(): FontStyle {
    return when (this) {
        "italic" -> FontStyle.Italic
        "normal" -> FontStyle.Normal
        "oblique" -> FontStyle.Oblique
        else -> throw IllegalArgumentException("Unknown FontStyle")
    }
}