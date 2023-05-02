package com.valentingrigorean.arcgis_maps_flutter.convert.geodatabase

import com.arcgismaps.tasks.geodatabase.SyncGeodatabaseParameters

fun SyncGeodatabaseParameters.toFlutterJson(): Any {
    val data = HashMap<String, Any>(4)
    data["keepGeodatabaseDeltas"] = keepGeodatabaseDeltas
    data["geodatabaseSyncDirection"] = geodatabaseSyncDirection.toFlutterValue()
    data["layerOptions"] = layerOptions.map { it.toFlutterJson() }
    data["rollbackOnFailure"] = shouldRollbackOnFailure
    return data
}