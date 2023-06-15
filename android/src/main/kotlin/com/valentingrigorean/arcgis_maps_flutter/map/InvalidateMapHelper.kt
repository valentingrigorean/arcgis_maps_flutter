package com.valentingrigorean.arcgis_maps_flutter.map

import android.util.Log
import android.view.Choreographer
import com.arcgismaps.mapping.view.DrawStatus
import com.arcgismaps.mapping.view.GeoView
import com.arcgismaps.mapping.view.LayerViewStatus
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach

class InvalidateMapHelper(geoView: GeoView, scope:CoroutineScope) {
    private var loadedCallbackPending = false

    init {
        geoView.drawStatus.onEach {
            Log.d(TAG, "drawStatusChanged: $it")
            if (!loadedCallbackPending) {
                Log.d(TAG, "drawStatusChanged: invalidate map not needed")
                return@onEach
            }
            if(it == DrawStatus.Completed){
                Log.d(TAG, "drawStatusChanged: invalidating map")
                loadedCallbackPending = false
                postFrameCallback {
                    postFrameCallback {
                        geoView.invalidate()
                    }
                }
            }
        }.launchIn(scope)

        geoView.layerViewStateChanged.onEach {
            var needsInvalidate = false
            for (layerViewStatus in it.layerViewState.status) {
                if (layerViewStatus == LayerViewStatus.Active) {
                    needsInvalidate = true
                    break
                }
            }
            if (needsInvalidate) {
                invalidateMapIfNeeded()
            }
        }.launchIn(scope)
    }

    /**
     * Invalidates the map view after the map has finished rendering.
     *
     *
     * gmscore GL renderer uses a [android.view.TextureView]. Android platform views that are
     * displayed as a texture after Flutter v3.0.0. require that the view hierarchy is notified after
     * all drawing operations have been flushed.
     *
     *
     * Since the GL renderer doesn't use standard Android views, and instead uses GL directly, we
     * notify the view hierarchy by invalidating the view.
     *
     *
     * To workaround this limitation, wait two frames. This ensures that at least the frame budget
     * (16.66ms at 60hz) have passed since the drawing operation was issued.
     */
    fun invalidateMapIfNeeded() {
        if (loadedCallbackPending) {
            return
        }
        loadedCallbackPending = true
    }

    private fun postFrameCallback(f: Runnable) {
        Choreographer.getInstance()
            .postFrameCallback { _: Long -> f.run() }
    }

    companion object {
        private val TAG = InvalidateMapHelper::class.java.simpleName

    }
}