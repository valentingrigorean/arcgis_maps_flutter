package com.valentingrigorean.arcgis_maps_flutter.convert.map

fun String.toPolygonIdValue() : Any{
    val data = HashMap<String, Any>(1)
    data["polygonId"] = this
    return data
}