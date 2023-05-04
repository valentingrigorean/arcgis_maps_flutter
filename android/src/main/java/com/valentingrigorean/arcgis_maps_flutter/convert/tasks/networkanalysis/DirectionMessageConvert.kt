package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.networkanalysis

import com.arcgismaps.tasks.networkanalysis.DirectionMessage

fun DirectionMessage.toFlutterJson(): Any{
    val data: MutableMap<String, Any> = HashMap(2)
    data["type"] = type.toFlutterValue()
    data["text"] = text
    return data
}