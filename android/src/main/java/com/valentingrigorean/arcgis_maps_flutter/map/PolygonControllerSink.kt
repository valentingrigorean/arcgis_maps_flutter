package com.valentingrigorean.arcgis_maps_flutter.map

import com.esri.arcgisruntime.symbology.SimpleLineSymbol

interface PolygonControllerSink : GraphicControllerSink {
    fun setFillColor(color: Int)
    fun setStrokeColor(color: Int)
    fun setStrokeWidth(width: Float)
    fun setStrokeStyle(style: SimpleLineSymbol.Style?)
}