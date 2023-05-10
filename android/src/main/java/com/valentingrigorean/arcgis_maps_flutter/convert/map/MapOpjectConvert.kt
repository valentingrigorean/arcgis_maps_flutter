package com.valentingrigorean.arcgis_maps_flutter.convert.map

fun String.toMarkerIdValue(): Any {
    val data = HashMap<String, Any>(1)
    data["markerId"] = this
    return data
}

fun String.toPolylineIdValue(): Any {
    val data = HashMap<String, Any>(1)
    data["polylineId"] = this
    return data
}

fun String.toPolygonIdValue(): Any {
    val data = HashMap<String, Any>(1)
    data["polygonId"] = this
    return data
}

