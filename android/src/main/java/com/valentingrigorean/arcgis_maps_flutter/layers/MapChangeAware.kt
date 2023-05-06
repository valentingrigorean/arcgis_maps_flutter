package com.valentingrigorean.arcgis_maps_flutter.layers

import com.arcgismaps.mapping.ArcGISMap

interface MapChangeAware {
    fun onMapChange(map: ArcGISMap?)
}