package com.valentingrigorean.arcgis_maps_flutter.flutterobject

class NativeObjectMessageSink(
    private val objectId: String?,
    private val messageSink: NativeMessageSink?
) : NativeMessageSink {
    private val data = HashMap<String, Any?>(3)
    override fun send(method: String, args: Any?) {
        data.clear()
        data["objectId"] = objectId
        data["method"] = method
        data["arguments"] = args
        messageSink!!.send("messageNativeObject", data)
    }
}