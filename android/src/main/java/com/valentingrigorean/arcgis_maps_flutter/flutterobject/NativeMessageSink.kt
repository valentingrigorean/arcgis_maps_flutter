package com.valentingrigorean.arcgis_maps_flutter.flutterobject

interface NativeMessageSink {
    fun send(method: String, args: Any?)
}