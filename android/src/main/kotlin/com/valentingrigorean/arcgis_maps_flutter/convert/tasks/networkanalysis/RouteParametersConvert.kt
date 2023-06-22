package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.networkanalysis

import com.arcgismaps.tasks.networkanalysis.RouteParameters
import com.valentingrigorean.arcgis_maps_flutter.convert.fromFlutterInstant
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toSpatialReferenceOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterValue
import com.valentingrigorean.arcgis_maps_flutter.convert.toUnitSystem

fun RouteParameters.toFlutterJson(): Any {
    val data: MutableMap<String, Any?> = HashMap(17)
    data["accumulateAttributeNames"] = accumulateAttributeNames
    data["directionsDistanceUnits"] = directionsDistanceUnits.toFlutterValue()
    data["directionsLanguage"] = directionsLanguage
    data["directionsStyle"] = directionsStyle.toFlutterValue()
    data["findBestSequence"] = findBestSequence
    if (startTime != null) {
        data["startTime"] = startTime!!.toFlutterValue()
    }
    if (outputSpatialReference != null) {
        data["outputSpatialReference"] = outputSpatialReference!!.toFlutterJson()
    }
    data["preserveFirstStop"] = preserveFirstStop
    data["preserveLastStop"] = preserveLastStop
    data["returnDirections"] = returnDirections
    data["returnPointBarriers"] = returnPointBarriers
    data["returnPolygonBarriers"] = returnPolygonBarriers
    data["returnPolylineBarriers"] = returnPolylineBarriers
    data["returnRoutes"] = returnRoutes
    data["returnStops"] = returnStops
    data["routeShapeType"] = routeShapeType.toFlutterValue()
    if (travelMode != null) {
        data["travelMode"] = travelMode!!.toFlutterJson()
    }
    return data
}

fun Any.toRouteParametersOrNull(): RouteParameters? {
    val data: Map<*, *> = this as Map<*, *>? ?: return null
    val routeParameters = RouteParameters()
    routeParameters.accumulateAttributeNames.addAll(
        data["accumulateAttributeNames"] as List<String>
    )
    routeParameters.directionsDistanceUnits =
        (data["directionsDistanceUnits"] as Int).toUnitSystem()
    routeParameters.directionsLanguage = data["directionsLanguage"] as String
    routeParameters.directionsStyle = (data["directionsStyle"] as Int).toDirectionsStyle()
    routeParameters.findBestSequence = data["findBestSequence"] as Boolean
    val startTime = data["startTime"] as String?
    if (startTime != null) {
        routeParameters.startTime = startTime.fromFlutterInstant()
    }
    routeParameters.outputSpatialReference =
        data["outputSpatialReference"]?.toSpatialReferenceOrNull()
    routeParameters.preserveFirstStop = data["preserveFirstStop"] as Boolean
    routeParameters.preserveLastStop = data["preserveLastStop"] as Boolean
    routeParameters.returnDirections = data["returnDirections"] as Boolean
    routeParameters.returnPointBarriers = data["returnPointBarriers"] as Boolean
    routeParameters.returnPolygonBarriers = data["returnPolygonBarriers"] as Boolean
    routeParameters.returnPolylineBarriers = data["returnPolylineBarriers"] as Boolean
    routeParameters.returnRoutes = data["returnRoutes"] as Boolean
    routeParameters.returnStops = data["returnStops"] as Boolean
    routeParameters.returnRoutes = data["returnRoutes"] as Boolean
    routeParameters.travelMode = data["travelMode"]?.toTravelModeOrNull()

    val stopsRaw = data["stops"] as List<Any>
    if (stopsRaw != null) {
        routeParameters.setStops(stopsRaw.map { it.toStopOrNull()!! })
    }
    return routeParameters
}