package com.valentingrigorean.arcgis_maps_flutter.data

import com.arcgismaps.data.Geodatabase
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject
import com.valentingrigorean.arcgis_maps_flutter.loadable.LoadableNativeHandler
import io.flutter.plugin.common.MethodChannel

class GeodatabaseNativeObject(objectId: String, geodatabase: Geodatabase) :
    BaseNativeObject<Geodatabase>(
        objectId, geodatabase, arrayOf(
            LoadableNativeHandler(geodatabase)
        )
    ) {
    override fun onMethodCall(method: String, args: Any?, result: MethodChannel.Result) {
        when (method) {
            "geodatabase#close" -> {
                nativeObject.close()
                result.success(null)
            }

            else -> super.onMethodCall(method, args, result)
        }
    }
}