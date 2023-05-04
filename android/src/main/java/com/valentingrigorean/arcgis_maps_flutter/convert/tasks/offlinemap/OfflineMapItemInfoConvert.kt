package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.offlinemap

import com.arcgismaps.tasks.offlinemaptask.OfflineMapItemInfo
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterValue

fun OfflineMapItemInfo.toFlutterJson(): Any{
    val data = HashMap<String, Any>(7)
    data["accessInformation"] = accessInformation
    data["itemDescription"] = description
    data["snippet"] = snippet
    data["tags"] = tags
    data["termsOfUse"] = termsOfUse
    data["title"] = title
    if (thumbnail != null) {
        data["thumbnail"] = thumbnail!!.toFlutterValue()
    }
    return data
}