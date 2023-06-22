package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.geodatabase

import com.arcgismaps.tasks.geodatabase.GenerateLayerOption
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterLong

fun GenerateLayerOption.toFlutterJson(): Any {
    val data = HashMap<String, Any>(5)
    data["layerId"] = layerId
    data["includeRelated"] = includeRelated
    data["queryOption"] = queryOption.toFlutterValue()
    data["useGeometry"] = useGeometry
    data["whereClause"] = whereClause
    return data
}

fun Any.toGenerateLayerOptionOrNull(): GenerateLayerOption? {
    val data: Map<*, *> = this as Map<*, *>? ?: return null
    val layerOption = GenerateLayerOption()
    layerOption.layerId = data["layerId"]!!.toFlutterLong()
    layerOption.includeRelated = data["includeRelated"] as Boolean
    layerOption.queryOption = (data["queryOption"] as Int).toGenerateLayerQueryOption()
    layerOption.useGeometry = data["useGeometry"] as Boolean
    layerOption.whereClause = data["whereClause"] as String? ?: ""
    return layerOption
}
