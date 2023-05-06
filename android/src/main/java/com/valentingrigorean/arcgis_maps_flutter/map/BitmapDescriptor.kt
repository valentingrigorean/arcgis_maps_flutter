package com.valentingrigorean.arcgis_maps_flutter.map

import com.arcgismaps.mapping.symbology.Symbol

interface BitmapDescriptor {
    interface BitmapDescriptorListener {
        fun onLoaded(symbol: Symbol)
        fun onFailed()
    }

    fun createSymbolAsync(loader: BitmapDescriptorListener)
}