package com.valentingrigorean.arcgis_maps_flutter.convert

fun Any.toFlutterLong(): Long {
    return when (this) {
        is Int -> this.toLong()
        is Long -> this
        else -> throw IllegalArgumentException("Long or Int expected")
    }
}

fun Any.toFlutterInt(): Int {
    return when (this) {
        is Int -> this
        is Long -> this.toInt()
        else -> throw IllegalArgumentException("Long or Int expected")
    }
}