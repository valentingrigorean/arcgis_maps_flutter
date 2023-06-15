package com.valentingrigorean.arcgis_maps_flutter.convert

fun Throwable.toFlutterJson(withStackTrace: Boolean = true): Any {
    val json = HashMap<String, Any>(2)
    json["errorMessage"] = localizedMessage
    if (withStackTrace) {
        json["nativeStackTrace"] = stackTraceToString()
    }
    return json
}