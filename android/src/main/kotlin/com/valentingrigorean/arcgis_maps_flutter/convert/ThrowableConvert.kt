package com.valentingrigorean.arcgis_maps_flutter.convert

fun Throwable.toFlutterJson(withStackTrace: Boolean = true,addFlutterFlag: Boolean = true): Any {
    val json = HashMap<String, Any>(2)
    json["errorMessage"] = localizedMessage
    if (withStackTrace) {
        json["nativeStackTrace"] = stackTraceToString()
    }
    if(addFlutterFlag){
        json["flutterError"] = true
    }
    return json
}