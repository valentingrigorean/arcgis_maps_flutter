package com.valentingrigorean.arcgis_maps_flutter.mapping.symbology

import com.valentingrigorean.arcgis_maps_flutter.map.GraphicControllerSink

interface MarkerControllerSink : GraphicControllerSink {
    fun setSelectedScale(selectedScale: Float)
    fun setIcon(bitmapDescriptor: BitmapDescriptor?)
    fun setBackground(bitmapDescriptor: BitmapDescriptor?)
    fun setIconOffset(offsetX: Float, offsetY: Float)
    fun setOpacity(opacity: Float)
    fun setAngle(angle: Float)
}