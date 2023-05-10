package com.valentingrigorean.arcgis_maps_flutter.mapping.symbology

import com.valentingrigorean.arcgis_maps_flutter.map.GraphicControllerSink

interface MarkerControllerSink : GraphicControllerSink {

    var selectedScale: Float

    var icon: BitmapDescriptor?

    var background: BitmapDescriptor?

    var opacity: Float

    var angle: Float
    fun setIconOffset(offsetX: Float, offsetY: Float)
}