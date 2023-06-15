package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.networkanalysis

import com.arcgismaps.tasks.networkanalysis.Stop
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toPointOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterValue

fun Stop.toFlutterJson(): Any {
    val data = HashMap<String, Any>(7)
    data["arrivalCurbApproach"] = arrivalCurbApproach.toFlutterValue()
    data["departureCurbApproach"] = departureCurbApproach.toFlutterValue()
    data["currentBearingTolerance"] = currentBearingTolerance
    data["distanceToNetworkLocation"] = distanceToNetworkLocation
    if (geometry != null)
        data["geometry"] = geometry!!.toFlutterJson()!!
    if (arrivalTime != null)
        data["arrivalTime"] = arrivalTime!!.toFlutterValue()
    data["arrivalTimeShift"] = arrivalTimeShift
    if(departureTime != null)
        data["departureTime"] = departureTime!!.toFlutterValue()
    if(timeWindowStart != null)
        data["timeWindowStart"] = timeWindowStart!!.toFlutterValue()
    if(timeWindowEnd != null)
        data["timeWindowEnd"] = timeWindowEnd!!.toFlutterValue()
    data["locationStatus"] = locationStatus.toFlutterValue()
    data["name"] = name
    data["stopType"] = stopType.toFlutterValue()
    data["stopID"] = stopId
    data["navigationLatency"] = navigationLatency
    data["navigationSpeed"] = navigationSpeed
    data["routeName"] = routeName
    data["sequence"] = sequence
    data["violationTime"] = violationTime
    data["waitTime"] = waitTime
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