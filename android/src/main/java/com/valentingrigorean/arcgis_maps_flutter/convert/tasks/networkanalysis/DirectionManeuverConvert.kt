package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.networkanalysis

import com.arcgismaps.tasks.networkanalysis.DirectionManeuver
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterValue

fun DirectionManeuver.toFlutterJson(): Any {
    val data: MutableMap<String, Any?> = HashMap(11)
    data["directionEvents"] = directionEvents.map { it.toFlutterJson() }
    data["directionText"] = directionText
    if (estimatedArrivalTime != null) {
        data["estimatedArrivalTime"] = estimatedArrivalTime!!.toFlutterValue()
    }
    data["estimatedArrivalTimeShift"] = estimatedArrivalTimeShift
    data["maneuverMessages"] = maneuverMessages.map { it.toFlutterJson() }
    data["fromLevel"] = fromLevel
    if (geometry != null) {
        data["geometry"] = geometry!!.toFlutterJson()
    }
    data["maneuverType"] = maneuverType.toFlutterValue()
    data["toLevel"] = toLevel
    data["length"] = length
    data["duration"] = duration
    return data
}