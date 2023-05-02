package com.valentingrigorean.arcgis_maps_flutter.convert.geodatabase

import com.arcgismaps.tasks.geodatabase.GenerateLayerOption

fun Any.toGenerateLayerOptionOrNull(): GenerateLayerOption? {
    val data: Map<*, *> = this as Map<*, *>? ?: return null
    val layerOption = GenerateLayerOption()
    layerOption.layerId = data["layerId"] as Long
    layerOption.includeRelated = data["includeRelated"] as Boolean
    layerOption.queryOption = (data["queryOption"] as Int).toGenerateLayerQueryOption()
    layerOption.useGeometry = data["useGeometry"] as Boolean
    layerOption.whereClause = data["whereClause"] as String? ?: ""
    return layerOption
}
