package com.valentingrigorean.arcgis_maps_flutter.convert.geometry

import com.arcgismaps.geometry.SpatialReference

fun SpatialReference.toFlutterJson(): Any {
    val data: MutableMap<String, Any> = HashMap(1)
    data["wkid"] = wkid
    return data
}

fun Any.toSpatialReferenceOrNull(): SpatialReference? {
    if (this !is Map<*, *>) {
        return null
    }
    val wkId = this["wkid"] as Int?
    if (wkId != null) {
        return SpatialReference(wkId)
    }
    val wkText = this["wkText"] as String?
    return if (wkText != null) {
        SpatialReference(wkText)
    } else null
}