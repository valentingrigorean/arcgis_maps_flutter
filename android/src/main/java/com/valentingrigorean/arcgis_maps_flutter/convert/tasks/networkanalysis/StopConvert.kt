package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.networkanalysis

import com.arcgismaps.tasks.networkanalysis.Stop
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toPointOrNull

fun Stop.toFlutterJson(): Any {
    val data = HashMap<String, Any>(7)
    if (geometry != null)
        data["geometry"] = geometry!!.toFlutterJson()!!
    data["name"] = name
    data["stopType"] = stopType.toFlutterValue()
    data["routeName"] = routeName
    data["curbApproach"] = curbApproach.toFlutterValue()
    data["currentBearingTolerance"] = currentBearingTolerance
    data["navigationLatency"] = navigationLatency
    data["navigationSpeed"] = navigationSpeed
    return data
}

fun Any.toStopOrNull(): Stop? {
    val data = this as Map<*, *>? ?: return null
    val stop = Stop(
        data["geometry"]?.toPointOrNull()!!
    )
    stop.name = data["name"] as String? ?: ""
    stop.stopType = (data["stopType"] as Int).toStopType()
    stop.routeName = data["routeName"] as String? ?: ""
    stop.curbApproach = (data["curbApproach"] as Int).toCurbApproach()
    stop.currentBearingTolerance = data["currentBearingTolerance"] as Double
    stop.navigationLatency = data["navigationLatency"] as Double
    stop.navigationSpeed = data["navigationSpeed"] as Double
    return stop
}