package com.valentingrigorean.arcgis_maps_flutter.map


import com.arcgismaps.Color
import com.arcgismaps.geometry.Geometry
import com.arcgismaps.mapping.view.GraphicsOverlay

interface GraphicControllerSink {
    fun add(graphicsOverlay: GraphicsOverlay)
    fun remove(graphicsOverlay: GraphicsOverlay)

    var visible: Boolean

    var zIndex: Int

    var geometry: Geometry?

    var isSelected: Boolean

    var consumeTapEvents: Boolean

    var selectedColor: Color?

    fun interpretGraphicController(
        data: Map<*, *>,
        symbolVisibilityFilterController: SymbolVisibilityFilterController?,
    )
}