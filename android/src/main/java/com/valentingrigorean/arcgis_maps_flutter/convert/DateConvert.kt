package com.valentingrigorean.arcgis_maps_flutter.convert

import java.time.Instant
import java.time.format.DateTimeFormatter
fun Instant.toFlutterValue() : String{
    val formatter = DateTimeFormatter.ISO_INSTANT
    return formatter.format(this)
}

fun String.fromFlutterDateTime() : Instant{
    val formatter = DateTimeFormatter.ISO_INSTANT
    return formatter.parse(this, Instant::from)
}