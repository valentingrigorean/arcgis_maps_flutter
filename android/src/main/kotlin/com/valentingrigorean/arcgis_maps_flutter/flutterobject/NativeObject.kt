package com.valentingrigorean.arcgis_maps_flutter.flutterobject

import io.flutter.plugin.common.MethodChannel

interface NativeObject {
    val objectId: String
    fun dispose()
    fun setMessageSink(messageSink: NativeMessageSink?)
    fun onMethodCall(method: String, args: Any?, result: MethodChannel.Result)
}