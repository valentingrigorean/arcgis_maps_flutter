package com.valentingrigorean.arcgis_maps_flutter.convert

import com.valentingrigorean.arcgis_maps_flutter.data.toFlutterFieldType

fun Map<String,Any?>.toFlutterValue() : Any{
    return map { (key,value)  -> key to value?.toFlutterFieldType() }.toMap()
}