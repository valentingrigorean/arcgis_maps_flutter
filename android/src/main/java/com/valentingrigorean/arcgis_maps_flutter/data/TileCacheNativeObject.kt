package com.valentingrigorean.arcgis_maps_flutter.data

import com.arcgismaps.mapping.layers.TileCache
import com.valentingrigorean.arcgis_maps_flutter.Convert
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler
import com.valentingrigorean.arcgis_maps_flutter.loadable.LoadableNativeHandler
import io.flutter.plugin.common.MethodChannel

class TileCacheNativeObject(objectId: String, tileCache: TileCache) : BaseNativeObject<TileCache>(
    objectId, tileCache, arrayOf<NativeHandler>(
        LoadableNativeHandler(tileCache)
    )
) {
    override fun onMethodCall(method: String, args: Any?, result: MethodChannel.Result) {
        when (method) {
            "tileCache#getAntialiasing" -> result.success(nativeObject.antialiasing)
            "tileCache#getCacheStorageFormat" -> result.success(if (nativeObject.getCacheStorageFormat() == TileCache.StorageFormat.UNKNOWN) -1 else nativeObject.getCacheStorageFormat().ordinal)
            "tileCache#getFullExtent" -> {
                val envelope = nativeObject.getFullExtent()
                result.success(
                    if (envelope == null) null else Convert.Companion.geometryToJson(
                        envelope
                    )
                )
            }

            else -> super.onMethodCall(method, args, result)
        }
    }
}