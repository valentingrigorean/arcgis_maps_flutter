package com.valentingrigorean.arcgis_maps_flutter.mapping.symbology

import com.arcgismaps.Color
import com.arcgismaps.mapping.symbology.SimpleLineSymbolStyle

interface PolygonControllerSink : GraphicControllerSink {

    var fillColor : Color

    var strokeColor : Color

    var strokeWidth : Float

    var strokeStyle : SimpleLineSymbolStyle
}