package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.offlinemap

import com.arcgismaps.tasks.offlinemaptask.OfflineMapUpdateCapabilities

fun OfflineMapUpdateCapabilities.toFlutterJson() : Any{
    val data = HashMap<String, Any>(2)
    data["supportsScheduledUpdatesForFeatures"] =   supportsScheduledUpdatesForFeatures
    data["supportsSyncWithFeatureServices"] = supportsSyncWithFeatureServices
    return data
}