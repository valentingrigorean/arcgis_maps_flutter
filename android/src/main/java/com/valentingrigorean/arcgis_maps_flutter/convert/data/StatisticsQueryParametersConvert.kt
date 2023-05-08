package com.valentingrigorean.arcgis_maps_flutter.convert.data

import com.arcgismaps.data.StatisticsQueryParameters
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toGeometryOrNull

fun Any.toStatisticsQueryParametersOrNull(): StatisticsQueryParameters?{
    val data = this as? Map<*, *> ?: return null
    val statisticDefinitions = (data["statisticDefinitions"] as List<Any>).map { it.toStatisticDefinitionOrNull()!! }
    return StatisticsQueryParameters(statisticDefinitions).apply {
        geometry = data["geometry"]?.toGeometryOrNull()
        whereClause = data["whereClause"] as String
        spatialRelationship = (data["spatialRelationship"] as Int).toSpatialRelationship()
        orderByFields.addAll((data["orderByFields"] as List<Any>).map { it.toOrderByOrNull()!! })
    }
}