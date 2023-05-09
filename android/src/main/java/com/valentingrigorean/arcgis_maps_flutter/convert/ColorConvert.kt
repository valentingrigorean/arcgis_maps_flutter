package com.valentingrigorean.arcgis_maps_flutter.convert

import com.arcgismaps.Color

fun Int.toArcgisColor() : Color {
    return Color(this)
}

fun android.graphics.Color.toArcgisColor() : Color {
    return Color(this.toArgb())
}