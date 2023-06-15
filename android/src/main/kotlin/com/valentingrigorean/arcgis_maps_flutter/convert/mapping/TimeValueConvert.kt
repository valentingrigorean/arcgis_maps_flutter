package com.valentingrigorean.arcgis_maps_flutter.convert.mapping

import com.arcgismaps.mapping.TimeValue
import com.valentingrigorean.arcgis_maps_flutter.convert.arcgisservices.toFlutterValue
import com.valentingrigorean.arcgis_maps_flutter.convert.arcgisservices.toTimeUnit

fun TimeValue.toFlutterJson(): Any {
    return mapOf(
        "duration" to duration,
        "unit" to unit.toFlutterValue()
    )
}

fun Any.toTimeValueOrNull(): TimeValue? {
    val data: Map<*, *> = this as Map<*, *>? ?: return null
    val duration = data["duration"] as Double
    val unit = (data["unit"] as Int).toTimeUnit()
    return TimeValue(duration, unit)
}
