package com.valentingrigorean.arcgis_maps_flutter.convert

import com.arcgismaps.Color

fun Int.toArcgisColor(): Color {
    return Color(this)
}

fun Any.toArcgisColorOrNull(): Color? {
    if (this is Int) {
        return Color(this)
    }
    if (this is Long) {
        return Color(this.toUInt().toInt())
    }
    return null
}

fun Any.fromFlutterColor(): Int {
    if (this is Int) {
        return this
    }
    if (this is Long) {
        return this.toUInt().toInt()
    }
    return 0
}

fun android.graphics.Color.toArcgisColor(): Color {
    return Color(this.toArgb())
}