package com.valentingrigorean.arcgis_maps_flutter.loadable

import com.esri.arcgisruntime.loadable.LoadStatusChangedEvent
import com.esri.arcgisruntime.loadable.LoadStatusChangedListener
import com.esri.arcgisruntime.loadable.Loadable
import com.valentingrigorean.arcgis_maps_flutter.Convert
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeHandler
import io.flutter.plugin.common.MethodChannel

class LoadableNativeHandler(loadable: Loadable) : BaseNativeHandler<Loadable?>(loadable),
    LoadStatusChangedListener {
    init {
        loadable.addLoadStatusChangedListener(this)
    }

    override fun disposeInternal() {
        super.disposeInternal()
        nativeHandler.removeLoadStatusChangedListener(this)
    }

    override fun onMethodCall(method: String, args: Any?, result: MethodChannel.Result): Boolean {
        when (method) {
            "loadable#getLoadStatus" -> {
                result.success(nativeHandler.getLoadStatus().ordinal)
                return true
            }

            "loadable#getLoadError" -> {
                result.success(
                    Convert.Companion.arcGISRuntimeExceptionToJson(
                        nativeHandler.getLoadError()
                    )
                )
                return true
            }

            "loadable#cancelLoad" -> {
                nativeHandler.cancelLoad()
                result.success(null)
                return true
            }

            "loadable#loadAsync" -> {
                nativeHandler.loadAsync()
                nativeHandler.addDoneLoadingListener(DoneListener(result))
                return true
            }

            "loadable#retryLoadAsync" -> {
                nativeHandler.retryLoadAsync()
                nativeHandler.addDoneLoadingListener(DoneListener(result))
                return true
            }
        }
        return false
    }

    override fun loadStatusChanged(loadStatusChangedEvent: LoadStatusChangedEvent) {
        sendMessage("loadable#loadStatusChanged", loadStatusChangedEvent.newLoadStatus.ordinal)
    }

    private inner class DoneListener(private val result: MethodChannel.Result) : Runnable {
        override fun run() {
            nativeHandler.removeDoneLoadingListener(this)
            if (!isDisposed) {
                result.success(null)
            }
        }
    }
}