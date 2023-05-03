package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.networkanalysis

import com.arcgismaps.tasks.networkanalysis.TravelMode

fun TravelMode.toFlutterJson(): Any {
    val data: MutableMap<String, Any> = HashMap(11)
    data["attributeParameterValues"] = attributeParameterValues.map { it.toFlutterJson() }
    data["travelModeDescription"] = description
    data["distanceAttributeName"] = distanceAttributeName
    data["impedanceAttributeName"] = impedanceAttributeName
    data["name"] = name
    data["outputGeometryPrecision"] = outputGeometryPrecision
    data["restrictionAttributeNames"] = restrictionAttributeNames
    data["timeAttributeName"] = timeAttributeName
    data["type"] = type
    data["useHierarchy"] = useHierarchy
    data["uTurnPolicy"] = uTurnPolicy.toFlutterValue()
    return data
}

fun Any.toTravelModeOrNull(): TravelMode? {
    val data: Map<*, *> = this as Map<*, *>? ?: return null
    val travelMode = TravelMode()
    for (attributeName in data["restrictionAttributeNames"] as List<String>) {
        travelMode.restrictionAttributeNames.add(attributeName)
    }
    travelMode.description = data["travelModeDescription"] as String
    travelMode.distanceAttributeName = data["distanceAttributeName"] as String
    travelMode.impedanceAttributeName = data["impedanceAttributeName"] as String
    travelMode.name = data["name"] as String
    travelMode.outputGeometryPrecision = data["outputGeometryPrecision"] as Double

    for (attributeName in data["restrictionAttributeNames"] as List<String>) {
        travelMode.restrictionAttributeNames.add(attributeName)
    }
    travelMode.timeAttributeName = data["timeAttributeName"] as String
    travelMode.type = data["type"] as String
    travelMode.useHierarchy = data["useHierarchy"] as Boolean
    travelMode.uTurnPolicy = (data["uTurnPolicy"] as Int).toUTurnPolicy()
    return travelMode
}