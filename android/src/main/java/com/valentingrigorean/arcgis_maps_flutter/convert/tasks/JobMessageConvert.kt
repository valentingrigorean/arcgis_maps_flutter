package com.valentingrigorean.arcgis_maps_flutter.convert.tasks

import com.arcgismaps.tasks.JobMessage
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterValue


fun JobMessage.toFlutterJson() : Map<String, Any>{
    val json = HashMap<String, Any>(4)
    json["message"] = message
    json["severity"] = severity.toFlutterValue()
    json["source"] = source.toFlutterValue()
    json["timestamp"] = timestamp.toFlutterValue()
    return json
}