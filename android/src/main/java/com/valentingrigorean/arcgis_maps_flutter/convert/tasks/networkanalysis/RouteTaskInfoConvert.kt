package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.networkanalysis

import com.arcgismaps.tasks.networkanalysis.RouteTaskInfo
import com.valentingrigorean.arcgis_maps_flutter.Convert

fun RouteTaskInfo.toFlutterJson() : Any{
    val json: MutableMap<String, Any?> = HashMap()
    json["accumulateAttributeNames"] = accumulateAttributeNames
    if (costAttributes != null) {
        val costAttributes: MutableMap<String, Any> = HashMap(routeTaskInfo.costAttributes.size)
        routeTaskInfo.costAttributes.forEach { (key: String, value: CostAttribute) ->
            costAttributes[key] = ConvertRouteTask.costAttributeToJson(value)
        }
        json["costAttributes"] = costAttributes
    }
    json["defaultTravelModeName"] = routeTaskInfo.defaultTravelModeName
    json["directionsDistanceUnits"] = routeTaskInfo.directionsDistanceUnits.ordinal
    json["directionsLanguage"] = routeTaskInfo.directionsLanguage
    json["directionsStyle"] = routeTaskInfo.directionsStyle.ordinal
    json["findBestSequence"] = routeTaskInfo.isFindBestSequence
    json["maxLocatingDistance"] = routeTaskInfo.maxLocatingDistance
    if (routeTaskInfo.startTime != null) {
        json["startTime"] = Convert.Companion.toCalendarFromISO8601(routeTaskInfo.startTime)
    }
    json["networkName"] = routeTaskInfo.networkName
    if (routeTaskInfo.outputSpatialReference != null) {
        json["outputSpatialReference"] =
            Convert.Companion.spatialReferenceToJson(routeTaskInfo.outputSpatialReference)
    }
    json["preserveFirstStop"] = routeTaskInfo.isPreserveFirstStop
    json["preserveLastStop"] = routeTaskInfo.isPreserveLastStop
    if (routeTaskInfo.restrictionAttributes != null) {
        val restrictionAttributes: MutableMap<String, Any> =
            HashMap(routeTaskInfo.restrictionAttributes.size)
        routeTaskInfo.restrictionAttributes.forEach { (key: String, value: RestrictionAttribute) ->
            restrictionAttributes[key] = ConvertRouteTask.restrictionAttributeToJson(value)
        }
        json["restrictionAttributes"] = restrictionAttributes
    }
    json["routeShapeType"] = routeTaskInfo.routeShapeType.ordinal
    json["supportedLanguages"] = routeTaskInfo.supportedLanguages
    json["supportedRestrictionUsageParameterValues"] =
        routeTaskInfo.supportedRestrictionUsageParameterValues
    json["directionsSupport"] = routeTaskInfo.directionsSupport.ordinal
    val travelModes: MutableList<Any> = ArrayList(routeTaskInfo.travelModes.size)
    routeTaskInfo.travelModes.forEach(Consumer { travelMode: TravelMode ->
        travelModes.add(
            ConvertRouteTask.travelModeToJson(travelMode)
        )
    })
    json["travelModes"] = travelModes
    json["supportsRerouting"] = routeTaskInfo.isSupportsRerouting
    return json
}