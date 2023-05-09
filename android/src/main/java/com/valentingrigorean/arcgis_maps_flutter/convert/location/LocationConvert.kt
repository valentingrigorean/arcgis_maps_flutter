package com.valentingrigorean.arcgis_maps_flutter.convert.location

import com.arcgismaps.location.Location
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterValue

fun Location.toFlutterJson(): Any {
    val json: MutableMap<String, Any?> = HashMap(7)
    json["course"] = course
    json["horizontalAccuracy"] = horizontalAccuracy
    json["lastKnown"] = lastKnown
    json["position"] = position.toFlutterJson()
    json["speed"] = speed
    json["timestamp"] = timestamp.toFlutterValue()
    json["verticalAccuracy"] = verticalAccuracy
    return json
}