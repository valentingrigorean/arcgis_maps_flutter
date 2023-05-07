package com.valentingrigorean.arcgis_maps_flutter.convert.geometry

import com.arcgismaps.geometry.GeodeticDistanceResult

fun GeodeticDistanceResult.toFlutterJson() : Any{
    val data: MutableMap<String, Any?> = HashMap(4)
    data["distance"] = distance
    data["distanceUnitId"] = distanceUnit.linearUnitId.toFlutterValue()
    data["azimuth1"] = azimuth1
    data["azimuth2"] = azimuth2
    data["angularUnitId"] = azimuthUnit.angularUnitId.toFlutterValue()
    return data
}