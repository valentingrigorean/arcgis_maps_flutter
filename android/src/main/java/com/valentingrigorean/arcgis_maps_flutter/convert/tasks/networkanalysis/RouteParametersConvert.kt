package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.networkanalysis

import com.arcgismaps.tasks.networkanalysis.RouteParameters
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterValue

fun RouteParameters.toFlutterJson() : Any{
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