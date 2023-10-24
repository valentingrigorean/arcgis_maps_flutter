package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.geocode

import com.arcgismaps.tasks.geocode.GeocodeResult
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.data.toFlutterFieldType

fun GeocodeResult.toFlutterJson(): Any {
    val data: MutableMap<String, Any?> = HashMap(6)
    val flutterAttributes: MutableMap<String, Any> = HashMap(attributes.size)
    attributes.forEach { (k: String, v: Any?) ->
        flutterAttributes[k] = v.toFlutterFieldType()
    }
    data["attributes"] = flutterAttributes
    if (displayLocation != null) {
        data["displayLocation"] = displayLocation!!.toFlutterJson()
    }
    if (extent != null) {
        data["extent"] = extent!!.toFlutterJson()
    }
    if (inputLocation != null) {
        data["inputLocation"] = inputLocation!!.toFlutterJson()
    }
    data["label"] = label
    if (routeLocation != null) {
        data["routeLocation"] = routeLocation!!.toFlutterJson()
    }
    data["score"] = score
    return data
}



