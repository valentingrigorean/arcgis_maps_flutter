package com.valentingrigorean.arcgis_maps_flutter.tasks.tilecache

import com.esri.arcgisruntime.tasks.tilecache.ExportTileCacheParameters
import com.valentingrigorean.arcgis_maps_flutter.Convert
import com.valentingrigorean.arcgis_maps_flutter.utils.toMap
import java.util.stream.Collectors

object ConvertTileCache : Convert() {
    fun toExportTileCacheParameters(o: Any?): ExportTileCacheParameters {
        val data: Map<*, *> = Convert.Companion.toMap(
            o!!
        )
        val parameters = ExportTileCacheParameters()
        val areaOfInterest = data["areaOfInterest"]
        if (areaOfInterest != null) {
            parameters.areaOfInterest = Convert.Companion.toGeometry(areaOfInterest)
        }
        parameters.compressionQuality = Convert.Companion.toFloat(
            data["compressionQuality"]
        )
        parameters.levelIDs.addAll(Convert.Companion.toList(
            data["levelIds"]!!
        ).stream().map<Int> { i: Any? -> Convert.Companion.toInt(i) }
            .collect<List<Int>, Any>(Collectors.toList<Int>()))
        return parameters
    }

    fun exportTileCacheParametersToJson(parameters: ExportTileCacheParameters): Any {
        val data: MutableMap<String, Any?> = HashMap(3)
        if (parameters.areaOfInterest != null) {
            data["areaOfInterest"] =
                Convert.Companion.geometryToJson(parameters.areaOfInterest)
        }
        data["compressionQuality"] = parameters.compressionQuality
        data["levelIds"] = parameters.levelIDs
        return data
    }
}