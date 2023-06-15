package com.valentingrigorean.arcgis_maps_flutter.convert.mapping

import com.arcgismaps.mapping.Viewpoint
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toPointOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.toMap
import org.json.JSONObject

fun Viewpoint.toFlutterJson(): Any {
    val jsonStr = toJson()
    return JSONObject(jsonStr).toMap()
}

fun Any.toViewpointOrNull() : Viewpoint? {
    val data = this as? Map<*, *> ?: return null
    val scale = data["scale"] as Double
    val targetGeometry = data["targetGeometry"]?.toPointOrNull()!!
    return Viewpoint(targetGeometry, scale)
}