package com.valentingrigorean.arcgis_maps_flutter.mapping.symbology

import com.arcgismaps.mapping.symbology.SimpleLineSymbolStyle
import com.valentingrigorean.arcgis_maps_flutter.map.GraphicControllerSink

interface PolygonControllerSink : GraphicControllerSink {
    fun setFillColor(color: Int)
    fun setStrokeColor(color: Int)
    fun setStrokeWidth(width: Float)
    fun setStrokeStyle(style: SimpleLineSymbolStyle)
}