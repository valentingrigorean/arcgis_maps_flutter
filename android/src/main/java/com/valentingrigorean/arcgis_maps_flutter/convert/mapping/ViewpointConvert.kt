package com.valentingrigorean.arcgis_maps_flutter.convert.mapping

import com.arcgismaps.mapping.Viewpoint
import com.valentingrigorean.arcgis_maps_flutter.convert.toMap
import org.json.JSONObject

fun Viewpoint.toFlutterJson(): Any {
    val jsonStr = toJson()
    return JSONObject(jsonStr).toMap()
}