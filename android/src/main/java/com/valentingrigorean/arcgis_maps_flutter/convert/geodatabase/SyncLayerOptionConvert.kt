package com.valentingrigorean.arcgis_maps_flutter.convert.geodatabase

import com.arcgismaps.tasks.geodatabase.SyncLayerOption

fun SyncLayerOption.toFlutterJson(): Any {
    val data = HashMap<String, Any>(2)
    data["layerId"] = layerId
    data["syncDirection"] = syncDirection.toFlutterValue()
    return data
}

fun Any.toSyncLayerOptionOrNull(): SyncLayerOption? {
    val data: Map<*, *> = this as Map<*, *>? ?: return null
    val layerId = data["layerId"] as Long
    val syncDirection = data["syncDirection"] as Int
    return SyncLayerOption(
        layerId,
        syncDirection.toSyncDirection()
    )
}