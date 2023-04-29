package com.valentingrigorean.arcgis_maps_flutter.flutterobject

import io.flutter.plugin.common.MethodChannel

abstract class BaseNativeObject<T> protected constructor(
    override val objectId: String,
    val nativeObject: T,
    private val nativeHandlers: Array<NativeHandler>
) : NativeObject, NativeMessageSink {
    private var nativeObjectMessageSink: NativeObjectMessageSink? = null
    private var messageSink: NativeMessageSink? = null
    private var isDisposed = false

    init {
        for (nativeHandler in nativeHandlers) {
            nativeHandler.setMessageSink(this)
        }
    }

    override fun send(method: String, args: Any?) {
        if (messageSink == null || isDisposed) {
            return
        }
        nativeObjectMessageSink!!.send(method, args)
    }

    override fun setMessageSink(messageSink: NativeMessageSink?) {
        this.messageSink = messageSink
        nativeObjectMessageSink = messageSink?.let { NativeObjectMessageSink(objectId, it) }
    }

    override fun dispose() {
        if (isDisposed) {
            return
        }
        isDisposed = true
        disposeInternal()
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

    protected open fun disposeInternal() {}
    protected fun getMessageSink(): NativeMessageSink? {
        return messageSink
    }

    protected val nativeObjectStorage: NativeObjectStorage
        protected get() = NativeObjectStorage.instance
}