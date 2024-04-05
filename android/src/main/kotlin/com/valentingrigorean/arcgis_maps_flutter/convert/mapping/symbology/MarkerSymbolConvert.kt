package com.valentingrigorean.arcgis_maps_flutter.convert.mapping.symbology

import com.arcgismaps.mapping.symbology.MarkerSymbol

fun MarkerSymbol.interpretMarkerSymbol(data: Map<*, *>) {
    data["angle"]?.let {
        angle = it as Float
    }
    data["angleAlignment"]?.let {
        angleAlignment = (it as String).toSymbolAngleAlignment()
    }

    data["leaderOffset"]?.let {
        val arr = it as List<*>
        leaderOffsetX = arr[0] as Float
        leaderOffsetY = arr[1] as Float
    }

    data["offset"]?.let {
        val arr = it as List<*>
        offsetX = arr[0] as Float
        offsetY = arr[1] as Float
    }
}