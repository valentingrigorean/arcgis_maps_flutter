package com.valentingrigorean.arcgis_maps_flutter.convert.mapping

import com.arcgismaps.mapping.GeoElement
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterValue

fun GeoElement.toFlutterJson(): Any {
    val data = HashMap<String, Any>(2)
    data["attributes"] = attributes.toFlutterValue()
    if (geometry != null)
        data["geometry"] = geometry!!.toFlutterJson()!!
    return data
}