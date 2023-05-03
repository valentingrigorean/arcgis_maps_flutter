package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.networkanalysis

import com.arcgismaps.tasks.networkanalysis.CostAttribute
import com.valentingrigorean.arcgis_maps_flutter.data.toFlutterFieldType


fun CostAttribute.toFlutterJson(): Any {
    val json: MutableMap<String, Any> = HashMap(2)
    json["parameterValues"] =
        parameterValues.map { entry -> Pair(entry.key, entry.value.toFlutterFieldType()) }.toMap()
    json["units"] = unit.toFlutterValue()
    return json
}