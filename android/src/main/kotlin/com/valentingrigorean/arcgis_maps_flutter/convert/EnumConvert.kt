package com.valentingrigorean.arcgis_maps_flutter.convert

import com.arcgismaps.LoadStatus
import com.arcgismaps.UnitSystem

fun LoadStatus.toFlutterValue(): Int {
    return when (this) {
        LoadStatus.NotLoaded -> 0
        LoadStatus.Loading -> 1
        LoadStatus.Loaded -> 2
        is LoadStatus.FailedToLoad -> 3
    }
}

fun LoadStatus.FailedToLoad.toFlutterJson(): Any {
    return mapOf(
        "errorMessage" to this.error.message,
    )
}


fun UnitSystem.toFlutterValue(): Int {
    return when (this) {
        UnitSystem.Imperial -> 0
        UnitSystem.Metric -> 1
    }
}

fun Int.toUnitSystem(): UnitSystem {
    return when (this) {
        0 -> UnitSystem.Imperial
        1 -> UnitSystem.Metric
        else -> throw IllegalArgumentException("Invalid UnitSystem value $this")
    }
}