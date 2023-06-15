package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.offlinemap

import com.arcgismaps.tasks.offlinemaptask.OfflineMapItemInfo
import com.valentingrigorean.arcgis_maps_flutter.convert.toBitmapDrawable
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterValue

fun OfflineMapItemInfo.toFlutterJson(): Any {
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

fun Any.toOfflineMapItemInfoOrNull(): OfflineMapItemInfo? {
    val data: Map<*, *> = this as Map<*, *>? ?: return null
    val mapItemInfo = OfflineMapItemInfo()
    mapItemInfo.accessInformation = data["accessInformation"] as String
    mapItemInfo.description = data["itemDescription"] as String
    mapItemInfo.snippet = data["snippet"] as String
    for (item in data["tags"] as List<String>) {
        mapItemInfo.tags.add(item)
    }
    mapItemInfo.termsOfUse = data["termsOfUse"] as String
    mapItemInfo.title = data["title"] as String
    val thumbnail = data["thumbnail"] as ByteArray?
    if (thumbnail != null) {
        mapItemInfo.thumbnail = thumbnail.toBitmapDrawable()!!
    }
    return mapItemInfo
}