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

fun Any.toSyncGeodatabaseParametersOrNull() : SyncGeodatabaseParameters?{
    val data = this as Map<*, *>? ?: return null
    val layerOptions =
        (data["layerOptions"] as List<Any>).map { it.toSyncLayerOptionOrNull()!! }
    val parameters = SyncGeodatabaseParameters()
    parameters.keepGeodatabaseDeltas = data["keepGeodatabaseDeltas"] as Boolean
    parameters.geodatabaseSyncDirection = (data["geodatabaseSyncDirection"] as Int).toSyncDirection()
    for (layerOption in layerOptions) {
        parameters.layerOptions.add(layerOption)
    }
    parameters.shouldRollbackOnFailure = data["rollbackOnFailure"] as Boolean
    return parameters
}