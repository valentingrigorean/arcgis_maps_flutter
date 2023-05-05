package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.offlinemap

import com.arcgismaps.tasks.offlinemaptask.OfflineMapSyncResult

fun OfflineMapSyncResult.toFlutterJson() : Any{
    val data = HashMap<String, Any>(2)
    data["hasErrors"] = hasErrors
    data["isMobileMapPackageReopenRequired"] = isMobileMapPackageReopenRequired
    return data
}