package com.valentingrigorean.arcgis_maps_flutter.map

import android.content.Context
import androidx.lifecycle.Lifecycle
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class ArcgisMapFactory(
    private val binaryMessenger: BinaryMessenger,
    private val lifecycleProvider: () -> Lifecycle
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val params = args as Map<String, Any>
        return ArcgisMapController(viewId, context, params, binaryMessenger, lifecycleProvider)
    }
}