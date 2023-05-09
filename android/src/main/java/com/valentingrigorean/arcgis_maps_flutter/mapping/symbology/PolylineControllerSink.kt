package com.valentingrigorean.arcgis_maps_flutter.mapping.symbology

import com.arcgismaps.mapping.symbology.SimpleLineSymbolStyle
import com.valentingrigorean.arcgis_maps_flutter.map.GraphicControllerSink


interface PolylineControllerSink : GraphicControllerSink {
    fun setColor(color: Int)
    fun setWidth(width: Float)
    fun setStyle(style: SimpleLineSymbolStyle)
    fun setAntialias(antialias: Boolean)
}