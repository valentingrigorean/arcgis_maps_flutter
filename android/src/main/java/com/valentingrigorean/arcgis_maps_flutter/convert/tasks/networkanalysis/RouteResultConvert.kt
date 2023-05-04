package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.networkanalysis

import com.arcgismaps.tasks.networkanalysis.RouteResult

fun RouteResult.toFlutterJson() : Any{
    val data: MutableMap<String, Any> = HashMap(3)
    data["directionsLanguage"] = directionsLanguage
    data["messages"] = messages
    data["routes"] = routes.map { it.toFlutterJson() }
    return data
}