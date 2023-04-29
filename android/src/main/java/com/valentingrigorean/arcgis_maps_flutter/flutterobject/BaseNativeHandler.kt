package com.valentingrigorean.arcgis_maps_flutter.flutterobject

abstract class BaseNativeHandler<T> protected constructor(val nativeHandler: T) : NativeHandler {
    protected var isDisposed = false
        private set
    private var messageSink: NativeMessageSink? = null
    override fun dispose() {
        if (isDisposed) {
            return
        }
        isDisposed = true
        disposeInternal()
    }

    override fun setMessageSink(messageSink: NativeMessageSink?) {
        this.messageSink = messageSink
    }

    protected open fun disposeInternal() {}
    protected fun sendMessage(method: String, args: Any?) {
        if (messageSink != null && !isDisposed) {
            messageSink!!.send(method, args)
        }
    }
}