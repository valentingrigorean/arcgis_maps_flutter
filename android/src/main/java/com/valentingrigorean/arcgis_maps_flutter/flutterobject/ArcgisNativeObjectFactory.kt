package com.valentingrigorean.arcgis_maps_flutter.flutterobject

interface ArcgisNativeObjectFactory {
    fun createNativeObject(
        objectId: String,
        type: String,
        arguments: Any?,
        messageSink: NativeMessageSink
    ): NativeObject
}