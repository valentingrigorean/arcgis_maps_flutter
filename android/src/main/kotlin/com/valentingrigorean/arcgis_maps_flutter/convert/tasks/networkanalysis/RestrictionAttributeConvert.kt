package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.networkanalysis

import com.arcgismaps.tasks.networkanalysis.RestrictionAttribute
import com.valentingrigorean.arcgis_maps_flutter.data.toFlutterFieldType

fun RestrictionAttribute.toFlutterJson() : Any{
    return mapOf(
        "parameterValues" to parameterValues.map { pair -> Pair(pair.key,pair.value.toFlutterFieldType()) }.toMap(),
        "restrictionUsageParameterName" to restrictionUsageParameterName,
    )
}