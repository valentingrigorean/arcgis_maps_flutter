package com.valentingrigorean.arcgis_maps_flutter.convert.mapping.view

import com.arcgismaps.mapping.view.IdentifyLayerResult
import com.valentingrigorean.arcgis_maps_flutter.convert.mapping.toFlutterJson

fun IdentifyLayerResult.toFlutterJson(): Any {
    val data = HashMap<String, Any>(2)
    data["layerName"] = layerContent.name
    data["elements"] = geoElements.map { it.toFlutterJson() }
    return data
}