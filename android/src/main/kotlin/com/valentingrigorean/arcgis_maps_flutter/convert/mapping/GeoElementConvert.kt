package com.valentingrigorean.arcgis_maps_flutter.convert.mapping

import com.arcgismaps.mapping.GeoElement
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toFlutterJson

fun GeoElement.toFlutterJson(): Any {
    val data = HashMap<String, Any>(2)
    if (geometry != null)
        data["geometry"] = geometry!!.toFlutterJson()!!
    return data
}