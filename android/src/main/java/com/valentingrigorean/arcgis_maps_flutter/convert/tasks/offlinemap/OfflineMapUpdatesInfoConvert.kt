package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.offlinemap

import com.arcgismaps.tasks.offlinemaptask.OfflineMapUpdatesInfo

fun OfflineMapUpdatesInfo.toFlutterJson(): Any {
    val data = HashMap<String, Any>(4)
    data["downloadAvailability"] = downloadAvailability.toFlutterValue()
    data["isMobileMapPackageReopenRequired"] = isMobileMapPackageReopenRequired
    data["scheduledUpdatesDownloadSize"] = scheduledUpdatesDownloadSize
    data["uploadAvailability"] = uploadAvailability.toFlutterValue()
    return data
}