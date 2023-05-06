package com.valentingrigorean.arcgis_maps_flutter.map

import android.util.Log
import android.view.Choreographer

class InvalidateMapHelper(private val flutterMapViewDelegate: FlutterMapViewDelegate) :
    DrawStatusChangedListener, LayerViewStateChangedListener {
    private var loadedCallbackPending = false
    private var isDisposed = false

    init {
        flutterMapViewDelegate.addDrawStatusChangedListener(this)
        flutterMapViewDelegate.addLayerViewStateChangedListener(this)
    }

    fun dispose() {
        if (isDisposed) {
            return
        }
        isDisposed = true
        flutterMapViewDelegate.removeLayerViewStateChangedListener(this)
        flutterMapViewDelegate.removeDrawStatusChangedListener(this)
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

    override fun drawStatusChanged(drawStatusChangedEvent: DrawStatusChangedEvent) {
        Log.d(TAG, "drawStatusChanged: " + drawStatusChangedEvent.drawStatus.name)
        if (!loadedCallbackPending) {
            Log.d(TAG, "drawStatusChanged: invalidate map not needed")
            return
        }
        when (drawStatusChangedEvent.drawStatus) {
            DrawStatus.COMPLETED -> {
                Log.d(TAG, "drawStatusChanged: invalidating map")
                loadedCallbackPending = false
                postFrameCallback {
                    postFrameCallback {
                        if (flutterMapViewDelegate.mapView != null && !isDisposed) {
                            flutterMapViewDelegate.mapView.invalidate()
                        }
                    }
                }
            }
        }
    }

    override fun layerViewStateChanged(layerViewStateChangedEvent: LayerViewStateChangedEvent) {
        var needsInvalidate = false
        for (layerViewStatus in layerViewStateChangedEvent.layerViewStatus) {
            if (layerViewStatus == LayerViewStatus.ACTIVE) {
                needsInvalidate = true
                break
            }
        }
        if (needsInvalidate) {
            invalidateMapIfNeeded()
        }
    }

    companion object {
        private val TAG = InvalidateMapHelper::class.java.simpleName
        private fun postFrameCallback(f: Runnable) {
            Choreographer.getInstance()
                .postFrameCallback { frameTimeNanos: Long -> f.run() }
        }
    }
}