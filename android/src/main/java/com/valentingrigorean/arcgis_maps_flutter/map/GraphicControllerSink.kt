package com.valentingrigorean.arcgis_maps_flutter.map

import android.graphics.Color
import com.arcgismaps.geometry.Geometry
import com.arcgismaps.mapping.view.GraphicsOverlay

interface GraphicControllerSink {
    fun add(graphicsOverlay: GraphicsOverlay)
    fun remove(graphicsOverlay: GraphicsOverlay)
    var visible: Boolean
    fun setZIndex(zIndex: Int)
    fun setGeometry(geometry: Geometry?)

    var isSelected: Boolean
    fun canConsumeTapEvents(): Boolean
    fun setConsumeTapEvents(consumeTapEvent: Boolean)
    fun setSelectedColor(color: Color?)
}