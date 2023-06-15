package com.valentingrigorean.arcgis_maps_flutter.data

import com.arcgismaps.mapping.layers.TileCache
import com.valentingrigorean.arcgis_maps_flutter.convert.arcgisservices.toFlutterValue
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toGeometryOrNull
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject
import com.valentingrigorean.arcgis_maps_flutter.loadable.LoadableNativeHandler
import io.flutter.plugin.common.MethodChannel

class TileCacheNativeObject(objectId: String, tileCache: TileCache) : BaseNativeObject<TileCache>(
    objectId, tileCache, arrayOf(
        LoadableNativeHandler(tileCache)
    )
) {
    override fun onMethodCall(method: String, args: Any?, result: MethodChannel.Result) {
        when (method) {
            "tileCache#getAntialiasing" -> result.success(nativeObject.antialiasing)
            "tileCache#getCacheStorageFormat" -> result.success(nativeObject.cacheStorageFormat.toFlutterValue())
            "tileCache#getFullExtent" -> {
                result.success(
                    nativeObject.fullExtent?.toGeometryOrNull()
                )
            }

            else -> super.onMethodCall(method, args, result)
        }
    }
}