package com.valentingrigorean.arcgis_maps_flutter.layers

import com.esri.arcgisruntime.mapping.ArcGISMap

interface MapChangeAware {
    fun onMapChange(map: ArcGISMap?)
}