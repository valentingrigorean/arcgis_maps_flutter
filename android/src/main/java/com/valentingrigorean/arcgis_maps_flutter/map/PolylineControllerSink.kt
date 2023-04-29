package com.valentingrigorean.arcgis_maps_flutter.map

import com.esri.arcgisruntime.symbology.SimpleLineSymbol

interface PolylineControllerSink : GraphicControllerSink {
    fun setColor(color: Int)
    fun setWidth(width: Float)
    fun setStyle(style: SimpleLineSymbol.Style?)
    fun setAntialias(antialias: Boolean)
}