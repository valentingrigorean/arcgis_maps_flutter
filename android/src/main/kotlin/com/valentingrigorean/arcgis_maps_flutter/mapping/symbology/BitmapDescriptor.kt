package com.valentingrigorean.arcgis_maps_flutter.mapping.symbology

import com.arcgismaps.mapping.symbology.Symbol

interface BitmapDescriptor {
    fun createSymbol(): Symbol
}