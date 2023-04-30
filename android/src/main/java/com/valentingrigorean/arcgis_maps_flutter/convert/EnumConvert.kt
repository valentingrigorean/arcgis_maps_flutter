package com.valentingrigorean.arcgis_maps_flutter.convert

import com.arcgismaps.LoadStatus

fun LoadStatus.toFlutterValue() {
    when (this) {
        LoadStatus.NotLoaded -> 0
        LoadStatus.Loading -> 1
        LoadStatus.Loaded -> 2
        is LoadStatus.FailedToLoad -> 3
    }
}

fun LoadStatus.FailedToLoad.toFlutterJson(): Map<String, Any?> {
    return mapOf(
        "errorMessage" to this.error.message,
    )
}