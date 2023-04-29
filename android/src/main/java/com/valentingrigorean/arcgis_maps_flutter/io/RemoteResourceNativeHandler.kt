package com.valentingrigorean.arcgis_maps_flutter.io

import com.esri.arcgisruntime.io.RemoteResource
import com.esri.arcgisruntime.security.Credential
import com.valentingrigorean.arcgis_maps_flutter.Convert
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeHandler
import io.flutter.plugin.common.MethodChannel

class RemoteResourceNativeHandler(remoteResource: RemoteResource) :
    BaseNativeHandler<RemoteResource?>(remoteResource) {
    override fun onMethodCall(method: String, args: Any?, result: MethodChannel.Result): Boolean {
        return when (method) {
            "remoteResource#getUrl" -> {
                result.success(nativeHandler.getUri())
                true
            }

            "remoteResource#getCredential" -> {
                val credential = nativeHandler.getCredential()
                result.success(
                    if (credential != null) Convert.Companion.credentialToJson(
                        credential
                    ) else null
                )
                true
            }

            "remoteResource#setCredential" -> {
                val credential1: Credential =
                    Convert.Companion.toCredentials(args)
                nativeHandler.setCredential(credential1)
                result.success(null)
                true
            }

            else -> false
        }
    }
}