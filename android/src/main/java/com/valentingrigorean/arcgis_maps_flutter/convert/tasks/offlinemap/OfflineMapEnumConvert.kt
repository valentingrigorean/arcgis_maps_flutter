package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.offlinemap

import com.arcgismaps.tasks.offlinemaptask.OnlineOnlyServicesOption


fun OnlineOnlyServicesOption.toFlutterValue(): Int {
    return when (this) {
        OnlineOnlyServicesOption.Exclude -> 0
        OnlineOnlyServicesOption.Include -> 1
        OnlineOnlyServicesOption.UseAuthoredSettings -> 2
    }
}