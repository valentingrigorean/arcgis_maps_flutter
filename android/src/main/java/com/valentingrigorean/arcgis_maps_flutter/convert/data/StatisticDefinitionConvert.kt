package com.valentingrigorean.arcgis_maps_flutter.convert.data

import com.arcgismaps.data.StatisticDefinition

fun Any.toStatisticDefinitionOrNull(): StatisticDefinition? {
    val data = this as? Map<*, *> ?: return null
    val fieldName = data["fieldName"] as String
    val statisticType = (data["statisticType"] as Int).toStatisticType()
    val outputAlias = data["outputAlias"] as String
    return StatisticDefinition(
        fieldName, statisticType, outputAlias,
    )
}