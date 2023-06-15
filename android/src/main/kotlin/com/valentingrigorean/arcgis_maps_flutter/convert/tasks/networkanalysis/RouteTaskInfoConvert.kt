package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.networkanalysis

import com.arcgismaps.tasks.networkanalysis.RouteTaskInfo
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterValue

fun RouteTaskInfo.toFlutterJson() : Any{
    val json: MutableMap<String, Any?> = HashMap()
    json["accumulateAttributeNames"] = accumulateAttributeNames
    json["costAttributes"] = costAttributes.map { pair -> Pair(pair.key,pair.value.toFlutterJson()) }.toMap()
    json["defaultTravelModeName"] = defaultTravelModeName
    json["directionsDistanceUnits"] = directionsDistanceUnits.toFlutterValue()
    json["directionsLanguage"] = directionsLanguage
    json["directionsStyle"] = directionsStyle.toFlutterValue()
    json["findBestSequence"] = findBestSequence
    json["maxLocatingDistance"] =maxLocatingDistance
    if (startTime != null) {
        json["startTime"] = startTime!!.toFlutterValue()
    }
    json["networkName"] = networkName
    if (outputSpatialReference != null) {
        json["outputSpatialReference"] = outputSpatialReference!!.toFlutterJson()
    }
    json["preserveFirstStop"] = preserveFirstStop
    json["preserveLastStop"] = preserveLastStop
    json["restrictionAttributes"] = restrictionAttributes
    json["routeShapeType"] = routeShapeType.toFlutterValue()
    json["supportedLanguages"] = supportedLanguages
    json["supportedRestrictionUsageParameterValues"] =  supportedRestrictionUsageParameterValues
    json["directionsSupport"] = directionsSupport.toFlutterValue()
    json["travelModes"] = travelModes.map { it.toFlutterJson() }
    json["supportsRerouting"] = supportsRerouting
    return json
}