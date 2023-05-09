package com.valentingrigorean.arcgis_maps_flutter.map

import com.arcgismaps.mapping.symbology.Symbol

interface BitmapDescriptor {
    fun createSymbol(): Symbol
}