package com.valentingrigorean.arcgis_maps_flutter.convert.data

import com.arcgismaps.data.EditOperation
import com.arcgismaps.data.EditResult
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterJson


fun EditOperation.toFlutterValue(): Int {
    return when (this) {
        EditOperation.Add -> 0
        EditOperation.Update -> 1
        EditOperation.Delete -> 2
        else -> -1
    }
}


fun EditResult.toFlutterJson(): Any {
    val data = HashMap<String, Any>(6)
    data["completedWithErrors"] = completedWithErrors
    data["editOperation"] = editOperation.toFlutterValue()
    if(error != null)
        data["error"] = error!!.toFlutterJson(false)
    data["globalId"] = globalId
    data["objectId"] = objectId
    return data
}