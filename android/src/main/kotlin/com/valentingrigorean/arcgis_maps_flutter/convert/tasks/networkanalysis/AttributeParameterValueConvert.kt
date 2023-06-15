package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.networkanalysis

import com.arcgismaps.tasks.networkanalysis.AttributeParameterValue
import com.valentingrigorean.arcgis_maps_flutter.data.fromFlutterFieldOrNull
import com.valentingrigorean.arcgis_maps_flutter.data.toFlutterFieldType

fun AttributeParameterValue.toFlutterJson() : Any{
    val data: MutableMap<String, Any> = HashMap(3)
    data["attributeName"] = attributeName
    data["parameterName"] = parameterName
    if(parameterValue != null) {
        data["parameterValue"] = parameterValue!!.toFlutterFieldType()
    }
    return data
}

fun Any.toAttributeParameterValueOrNull() : AttributeParameterValue? {
    val data: Map<*, *> = this as Map<*, *>? ?: return null
    val attributeParameterValue = AttributeParameterValue()
    attributeParameterValue.attributeName = data["attributeName"] as String
    attributeParameterValue.parameterName = data["parameterName"] as String
    attributeParameterValue.parameterValue = data["parameterValue"]?.fromFlutterFieldOrNull()
    return attributeParameterValue
}