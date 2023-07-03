package com.valentingrigorean.arcgis_maps_flutter.map

import com.arcgismaps.mapping.ArcGISMap

interface MapChangeAware {
    fun onMapChange(map: ArcGISMap?)
}