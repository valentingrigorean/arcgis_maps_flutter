package com.valentingrigorean.arcgis_maps_flutter.flutterobject

import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job

abstract class BaseNativeObject<T> protected constructor(
    final override val objectId: String,
    val nativeObject: T,
    private val nativeHandlers: Array<NativeHandler>
) : NativeObject, NativeMessageSink {
    private val messageSinkImpl = NativeObjectMessageSinkImpl(objectId)
    private var isDisposed = false
    private val coroutineJob = Job()
    protected val scope = CoroutineScope(Dispatchers.Main + coroutineJob)

    init {
        for (nativeHandler in nativeHandlers) {
            nativeHandler.setMessageSink(messageSinkImpl)
        }
    }

    override fun send(method: String, args: Any?) {
        if (isDisposed) {
            return
        }
        messageSinkImpl.send(method, args)
    }

    override fun setMessageSink(messageSink: NativeMessageSink?) {
        messageSinkImpl.setMessageSink(messageSink)
    }

    override fun dispose() {
        if (isDisposed) {
            return
        }
        isDisposed = true
        coroutineJob.cancel()
        for (nativeHandler in nativeHandlers) {
            nativeHandler.setMessageSink(null)
            nativeHandler.dispose()
        }
    }

    override fun onMethodCall(method: String, args: Any?, result: MethodChannel.Result) {
        for (nativeHandler in nativeHandlers) {
            if (nativeHandler.onMethodCall(method, args, result)) {
                return
            }
        }
        result.notImplemented()
    }

    protected fun getMessageSink(): NativeMessageSink {
        return messageSinkImpl
    }

    protected val nativeObjectStorage: NativeObjectStorage
        get() = NativeObjectStorage.instance
}

private class NativeObjectMessageSinkImpl(
    private val objectId: String,
    private var messageSink: NativeMessageSink? = null,
) : NativeMessageSink {

    private val data = HashMap<String, Any?>(3)

    override fun send(method: String, args: Any?) {
       if(messageSink == null){
           return
       }
        data.clear()
        data["objectId"] = objectId
        data["method"] = method
        data["arguments"] = args
        messageSink!!.send("messageNativeObject", data)
    }

    fun setMessageSink(messageSink: NativeMessageSink?) {
        this.messageSink = messageSink
    }
}