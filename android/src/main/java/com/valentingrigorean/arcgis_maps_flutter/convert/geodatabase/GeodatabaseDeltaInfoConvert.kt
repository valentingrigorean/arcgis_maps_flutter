package com.valentingrigorean.arcgis_maps_flutter.convert.geodatabase

import com.arcgismaps.tasks.geodatabase.GeodatabaseDeltaInfo

fun GeodatabaseDeltaInfo.toFlutterJson(): Any {
    val data = HashMap<String, Any>(4)
    if (downloadDeltaPath != null) {
        data["downloadDeltaFileUrl"] = downloadDeltaPath!!
    }
    data["featureServiceUrl"] = featureServiceUrl
    data["geodatabaseFileUrl"] = geodatabasePath
    if (uploadDeltaPath != null) {
        data["uploadDeltaFileUrl"] = uploadDeltaPath!!
    }
    return data
}