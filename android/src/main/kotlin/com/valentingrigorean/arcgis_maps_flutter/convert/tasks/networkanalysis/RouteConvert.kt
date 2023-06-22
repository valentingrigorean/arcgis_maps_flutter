package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.networkanalysis

import com.arcgismaps.tasks.networkanalysis.Route
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toGeometryOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterValue

fun Route.toFlutterJson() : Any{
    val data: MutableMap<String, Any?> = HashMap(13)
    data["directionManeuvers"] = directionManeuvers.map { it.toFlutterJson() }
    if (startTime != null) {
        data["startTime"] = startTime!!.toFlutterValue()
    }
    data["startTimeShift"] = startTimeShift
    if (endTime != null) {
        data["endTime"] = endTime!!.toFlutterValue()
    }
    data["endTimeShift"] = endTimeShift
    data["totalLength"] = totalLength
    if (routeGeometry != null) {
        data["routeGeometry"] = routeGeometry!!.toFlutterJson()
    }
    data["stops"] = stops.map { it.toFlutterJson() }
    data["routeName"] = routeName
    data["totalTime"] = totalTime
    data["travelTime"] = travelTime
    data["violationTime"] = violationTime
    data["waitTime"] = waitTime
    return data
}