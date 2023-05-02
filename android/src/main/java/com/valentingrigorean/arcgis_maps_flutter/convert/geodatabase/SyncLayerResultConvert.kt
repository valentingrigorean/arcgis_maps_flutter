package com.valentingrigorean.arcgis_maps_flutter.convert.geodatabase

import com.arcgismaps.tasks.geodatabase.SyncLayerResult


fun SyncLayerResult.toFlutterJson() : Any {
    val data = HashMap<String, Any>(3)
    data["editResults"] = editResults.map { it.toFlutterJson() }
    if(layerId != null){
        data["layerId"] = layerId!!
    }
    data["tableName"] = tableName
    return data
}