package com.valentingrigorean.arcgis_maps_flutter.map

interface MarkerControllerSink : GraphicControllerSink {
    fun setSelectedScale(selectedScale: Float)
    fun setIcon(bitmapDescriptor: BitmapDescriptor?)
    fun setBackground(bitmapDescriptor: BitmapDescriptor?)
    fun setIconOffset(offsetX: Float, offsetY: Float)
    fun setOpacity(opacity: Float)
    fun setAngle(angle: Float)
}