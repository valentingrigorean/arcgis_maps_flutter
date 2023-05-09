package com.valentingrigorean.arcgis_maps_flutter.map

import com.arcgismaps.mapping.view.Graphic

interface MapTouchGraphicDelegate {
    fun canConsumeTaps(): Boolean
    fun didHandleGraphic(graphic: Graphic): Boolean
}