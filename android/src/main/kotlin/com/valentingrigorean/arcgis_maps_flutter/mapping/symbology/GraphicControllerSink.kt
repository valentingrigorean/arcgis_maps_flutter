package com.valentingrigorean.arcgis_maps_flutter.mapping.symbology


import com.arcgismaps.Color
import com.arcgismaps.geometry.Geometry
import com.arcgismaps.mapping.view.Graphic
import com.valentingrigorean.arcgis_maps_flutter.map.SymbolVisibilityFilterController

interface GraphicControllerSink {

    val graphic: Graphic

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