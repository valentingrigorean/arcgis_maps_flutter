package com.valentingrigorean.arcgis_maps_flutter.io

import com.esri.arcgisruntime.ApiKeyResource
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeHandler
import io.flutter.plugin.common.MethodChannel

class ApiKeyResourceNativeHandler(apiKeyResource: ApiKeyResource) :
    BaseNativeHandler<ApiKeyResource?>(apiKeyResource) {
    override fun onMethodCall(method: String, args: Any?, result: MethodChannel.Result): Boolean {
        return when (method) {
            "apiKeyResource#getApiKey" -> {
                result.success(nativeHandler.getApiKey())
                true
            }

            "apiKeyResource#setApiKey" -> {
                nativeHandler.setApiKey(args as String?)
                result.success(null)
                true
            }

            else -> false
        }
    }
}