package com.valentingrigorean.arcgis_maps_flutter.io

import com.arcgismaps.ApiKey
import com.arcgismaps.ApiKeyResource
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeHandler
import io.flutter.plugin.common.MethodChannel

class ApiKeyResourceNativeHandler(apiKeyResource: ApiKeyResource) :
    BaseNativeHandler<ApiKeyResource>(apiKeyResource) {
    override fun onMethodCall(method: String, args: Any?, result: MethodChannel.Result): Boolean {
        return when (method) {
            "apiKeyResource#getApiKey" -> {
                result.success(nativeHandler.apiKey?.toString())
                true
            }

            "apiKeyResource#setApiKey" -> {
                nativeHandler.apiKey = ApiKey.create(args as String)
                result.success(null)
                true
            }

            else -> false
        }
    }
}