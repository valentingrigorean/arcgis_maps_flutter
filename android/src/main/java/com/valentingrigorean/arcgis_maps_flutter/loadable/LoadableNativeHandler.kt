package com.valentingrigorean.arcgis_maps_flutter.loadable

import com.arcgismaps.LoadStatus
import com.arcgismaps.Loadable
import com.valentingrigorean.arcgis_maps_flutter.Convert
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterValue
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeHandler
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.launch

class LoadableNativeHandler(loadable: Loadable) : BaseNativeHandler<Loadable>(loadable) {
    init {
        loadable.loadStatus.onEach { status ->
                // Perform any action you want to do with the message here
                // You can send the message to the Flutter side using the sendMessage method
                sendMessage("loadable#loadStatusChanged", status)
            }.launchIn(scope)
    }


    override fun onMethodCall(method: String, args: Any?, result: MethodChannel.Result): Boolean {
        when (method) {
            "loadable#getLoadStatus" -> {
                result.success(nativeHandler.loadStatus.value.toFlutterValue())
                return true
            }

            "loadable#getLoadError" -> {
                val loadError = nativeHandler.loadStatus.value as? LoadStatus.FailedToLoad
                if (loadError != null) {
                    result.success(Convert.arcGISRuntimeExceptionToJson(loadError.error))
                } else {
                    result.success(null)
                }
                return true
            }

            "loadable#cancelLoad" -> {
                nativeHandler.cancelLoad()
                result.success(null)
                return true
            }

            "loadable#loadAsync" -> {
                scope.launch {
                    nativeHandler.load().onSuccess { result.success(null) }
                        .onFailure { result.error("loadable#loadAsync", it.message, it) }
                }
                return true
            }

            "loadable#retryLoadAsync" -> {
                scope.launch {
                    nativeHandler.retryLoad().onSuccess { result.success(null) }
                        .onFailure { result.error("loadable#retryLoadAsync", it.message, it) }
                }
                return true
            }
        }
        return false
    }
}