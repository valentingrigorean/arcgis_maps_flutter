package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.geocode

import com.arcgismaps.tasks.geocode.LocatorInfo
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toFlutterJson

fun LocatorInfo.toFlutterJson() : Any {
    val data: MutableMap<String, Any> = HashMap()
    data["name"] = name
    data["description"] = description
    data["intersectionResultAttributes"] = intersectionResultAttributes.map { it.toFlutterJson() }

    if (properties != null) {
        data["properties"] = properties
    }
    data["resultAttributes"] = resultAttributes.map { it.toFlutterJson() }
    data["searchAttributes"] = searchAttributes.map { it.toFlutterJson() }
    if (spatialReference != null) {
        data["spatialReference"] = spatialReference!!.toFlutterJson()
    }
    data["supportsPOI"] = supportsPoi
    data["supportsAddresses"] = supportsAddresses
    data["supportsIntersections"] = supportsIntersections
    data["supportsSuggestions"] = supportsSuggestions
    data["version"] = version
    return data
}