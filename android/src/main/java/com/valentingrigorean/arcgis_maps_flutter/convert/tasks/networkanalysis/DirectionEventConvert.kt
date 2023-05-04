package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.networkanalysis

import com.arcgismaps.tasks.networkanalysis.DirectionEvent
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterValue

fun DirectionEvent.toFlutterJson() : Any{
    val data: MutableMap<String, Any?> = HashMap(5)
    if (estimatedArrivalTime != null) {
        data["estimatedArrivalTime"] =estimatedArrivalTime!!.toFlutterValue()
    }
    data["estimatedArrivalTimeShift"] = estimatedArrivalTimeShift
    data["eventMessages"] = eventMessages
    data["eventText"] = eventText
    if (geometry != null) {
        data["geometry"] = geometry!!.toFlutterJson()
    }
    return data
}