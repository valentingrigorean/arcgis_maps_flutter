package com.valentingrigorean.arcgis_maps_flutter.convert

import java.time.Instant
import java.time.ZoneId
import java.time.format.DateTimeFormatter
fun Instant.toFlutterValue() : String{
    val formatter = DateTimeFormatter.ISO_INSTANT
    return formatter.format(this)
}

fun String.fromFlutterInstant() : Instant {
    val truncatedString = this.substring(0, this.length.coerceAtMost(23))
    val formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS").withZone(ZoneId.of("UTC"))
    return Instant.from(formatter.parse(truncatedString))
}