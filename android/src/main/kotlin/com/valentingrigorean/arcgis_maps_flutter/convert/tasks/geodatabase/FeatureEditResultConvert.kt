package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.geodatabase

import com.arcgismaps.data.FeatureEditResult
import com.valentingrigorean.arcgis_maps_flutter.convert.data.toFlutterJson

fun FeatureEditResult.toFlutterJson() : Any{
    val data = HashMap<String, Any>(1)
    data["attachmentResults"] = attachmentResults.map { it.toFlutterJson() }
    return data
}