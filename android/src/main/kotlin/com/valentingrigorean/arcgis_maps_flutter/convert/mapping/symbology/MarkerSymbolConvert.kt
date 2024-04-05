package com.valentingrigorean.arcgis_maps_flutter.convert.mapping.symbology

import com.arcgismaps.mapping.symbology.MarkerSymbol

fun MarkerSymbol.interpretMarkerSymbol(data: Map<*, *>) {
    data["angle"]?.let {
        angle = (it as Double).toFloat()
    }
    data["angleAlignment"]?.let {
        angleAlignment = (it as String).toSymbolAngleAlignment()
    }

    data["leaderOffset"]?.let {
        val arr = it as List<*>
        leaderOffsetX = (arr[0] as Double).toFloat()
        leaderOffsetY = (arr[1] as Double).toFloat()
    }

    data["offset"]?.let {
        val arr = it as List<*>
        offsetX = (arr[0] as Double).toFloat()
        offsetY = (arr[1] as Double).toFloat()
    }
}