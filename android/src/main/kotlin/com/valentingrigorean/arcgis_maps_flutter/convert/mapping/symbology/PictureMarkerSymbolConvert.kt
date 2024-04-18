package com.valentingrigorean.arcgis_maps_flutter.convert.mapping.symbology

import com.arcgismaps.mapping.symbology.PictureMarkerSymbol

fun PictureMarkerSymbol.interpretPictureMarkerSymbol(data: Map<*, *>) {
    interpretMarkerSymbol(data)
    data["height"]?.let {
        height = (it as Double).toFloat()
    }
    data["width"]?.let {
        width = (it as Double).toFloat()
    }
}