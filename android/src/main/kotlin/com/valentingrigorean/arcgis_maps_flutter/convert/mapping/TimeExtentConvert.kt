package com.valentingrigorean.arcgis_maps_flutter.convert.mapping

import com.arcgismaps.mapping.TimeExtent
import com.valentingrigorean.arcgis_maps_flutter.convert.fromFlutterInstant
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterValue

fun TimeExtent.toFlutterJson(): Any {
    return mapOf(
        "startTime" to startTime?.toFlutterValue(),
        "endTime" to endTime?.toFlutterValue()
    )
}

fun Any.toTimeExtentOrNull(): TimeExtent? {
    if (this == null) {
        return null
    }
    val map = this as? Map<*, *> ?: return null
    val startTime = map["startTime"] as String?
    val endTime = map["endTime"] as String?
    return TimeExtent(startTime?.fromFlutterInstant(), endTime?.fromFlutterInstant())
}