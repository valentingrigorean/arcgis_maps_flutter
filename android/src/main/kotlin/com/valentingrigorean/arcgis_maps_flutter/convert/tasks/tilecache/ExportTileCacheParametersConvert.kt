package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.tilecache

import com.arcgismaps.tasks.tilecache.ExportTileCacheParameters
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toGeometryOrNull

fun ExportTileCacheParameters.toFlutterJson(): Any {
    val data: MutableMap<String, Any?> = HashMap(3)
    if (areaOfInterest != null) {
        data["areaOfInterest"] = areaOfInterest?.toFlutterJson()
    }
    data["compressionQuality"] = compressionQuality
    data["levelIds"] = levelIds
    return data
}

fun Any.toExportTileCacheParametersOrNull(): ExportTileCacheParameters? {
    val data = this as Map<*, *>? ?: return null
    val parameters = ExportTileCacheParameters()
    parameters.areaOfInterest = data["areaOfInterest"]?.toGeometryOrNull()
    parameters.compressionQuality = (data["compressionQuality"] as Double).toFloat()
    parameters.levelIds.addAll(data["levelIds"] as List<Int>)
    return parameters
}