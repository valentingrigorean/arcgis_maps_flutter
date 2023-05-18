package com.valentingrigorean.arcgis_maps_flutter.flutterobject

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.cancel

abstract class BaseNativeHandler<T> protected constructor(val nativeHandler: T) : NativeHandler {
    private var messageSink: NativeMessageSink? = null
    private val coroutineJob = Job()
    protected val scope = CoroutineScope(Dispatchers.Main + coroutineJob)

    protected var isDisposed = false
        private set

    override fun dispose() {
        if (isDisposed) {
            return
        }
        isDisposed = true
        coroutineJob.cancel()
    }

    override fun setMessageSink(messageSink: NativeMessageSink?) {
        this.messageSink = messageSink
    }

    protected fun sendMessage(method: String, args: Any?) {
        if (messageSink != null && !isDisposed) {
            messageSink!!.send(method, args)
        }
    }
}