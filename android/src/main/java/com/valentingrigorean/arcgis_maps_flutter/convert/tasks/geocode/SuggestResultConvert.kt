package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.geocode

import com.arcgismaps.tasks.geocode.SuggestResult

fun SuggestResult.toFlutterJson(suggestResultId:String): Any {
    val data: MutableMap<String, Any> = HashMap(3)
    data["label"] = label
    data["isCollection"] = isCollection
    data["suggestResultId"] = suggestResultId
    return data
}