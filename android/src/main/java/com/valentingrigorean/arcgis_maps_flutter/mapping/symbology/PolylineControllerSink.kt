package com.valentingrigorean.arcgis_maps_flutter.mapping.symbology

import com.arcgismaps.Color
import com.arcgismaps.mapping.symbology.SimpleLineSymbolStyle
import com.valentingrigorean.arcgis_maps_flutter.map.GraphicControllerSink


interface PolylineControllerSink : GraphicControllerSink {

    var color: Color
    var width: Float
    var style: SimpleLineSymbolStyle
    var antialias: Boolean
}