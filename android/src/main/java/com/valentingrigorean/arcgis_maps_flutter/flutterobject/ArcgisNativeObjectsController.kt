package com.valentingrigorean.arcgis_maps_flutter.flutterobject

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class ArcgisNativeObjectsController(
    messenger: BinaryMessenger?,
    factory: ArcgisNativeObjectFactory
) : MethodCallHandler {
    private val channel: MethodChannel
    private val factory: ArcgisNativeObjectFactory
    private val messageSink: MessageSink
    private val storage: NativeObjectStorage

    init {
        channel = MethodChannel(messenger!!, "plugins.flutter.io/arcgis_channel/native_objects")
        this.factory = factory
        messageSink = MessageSink(channel)
        channel.setMethodCallHandler(this)
        storage = NativeObjectStorage.Companion.getInstance()
    }

    fun dispose() {
        channel.setMethodCallHandler(null)
        storage.clearAll()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "createNativeObject" -> {
                val args = call.arguments<Map<*, *>>()!!
                val objectId = args["objectId"] as String?
                val type = args["type"] as String?
                val arguments = args["arguments"]
                val nativeObject = factory.createNativeObject(
                    objectId!!, type!!, arguments, messageSink
                )
                storage.addNativeObject(nativeObject)
                result.success(null)
            }

            "destroyNativeObject" -> {
                val objectId = call.arguments<String>()
                storage.removeNativeObject(objectId!!)
                result.success(null)
            }

            "sendMessage" -> {
                val args = call.arguments<Map<*, *>>()!!
                val objectId = args["objectId"] as String?
                val method = args["method"] as String?
                val arguments = args["arguments"]
                val nativeObject = storage.getNativeObject(
                    objectId!!
                )
                if (nativeObject != null) {
                    nativeObject.onMethodCall(method!!, arguments, result)
                } else {
                    result.error("object_not_found", "Native object not found", null)
                }
            }

            else -> result.notImplemented()
        }
    }

    private class MessageSink(private val channel: MethodChannel) : NativeMessageSink {
        override fun send(method: String, args: Any?) {
            channel.invokeMethod(method, args)
        }
    }
}