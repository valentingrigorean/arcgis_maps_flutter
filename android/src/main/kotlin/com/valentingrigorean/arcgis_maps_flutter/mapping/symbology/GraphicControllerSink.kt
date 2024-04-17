package com.valentingrigorean.arcgis_maps_flutter.mapping.symbology


import com.arcgismaps.geometry.Geometry
import com.arcgismaps.mapping.symbology.Symbol
import com.arcgismaps.mapping.view.Graphic

interface GraphicControllerSink {

    val graphic: Graphic

    var isVisible: Boolean

    var zIndex: Int

    var geometry: Geometry?

    var symbol: Symbol?

    var isSelected: Boolean

    fun interpretGraphicController(
        data: Map<*, *>
    )
}