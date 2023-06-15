package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.geocode

import com.arcgismaps.tasks.geocode.LocatorAttribute

fun LocatorAttribute.toFlutterJson() : Any{
    val data: MutableMap<String, Any> = HashMap(3)
    data["name"] = name
    data["displayName"] = displayName
    data["required"] = required
    return data
}