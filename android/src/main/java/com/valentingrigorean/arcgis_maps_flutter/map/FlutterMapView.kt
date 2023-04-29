package com.valentingrigorean.arcgis_maps_flutter.map

import android.content.Context
import android.graphics.Bitmap
import android.util.AttributeSet
import android.util.Log
import android.view.ViewGroup
import android.widget.FrameLayout
import com.esri.arcgisruntime.concurrent.ListenableFuture
import com.esri.arcgisruntime.geometry.Geometry
import com.esri.arcgisruntime.geometry.Point
import com.esri.arcgisruntime.mapping.ArcGISMap
import com.esri.arcgisruntime.mapping.SelectionProperties
import com.esri.arcgisruntime.mapping.TimeExtent
import com.esri.arcgisruntime.mapping.Viewpoint
import com.esri.arcgisruntime.mapping.view.DrawStatusChangedListener
import com.esri.arcgisruntime.mapping.view.GraphicsOverlay
import com.esri.arcgisruntime.mapping.view.LayerViewStateChangedListener
import com.esri.arcgisruntime.mapping.view.LocationDisplay
import com.esri.arcgisruntime.mapping.view.MapScaleChangedListener
import com.esri.arcgisruntime.mapping.view.MapView
import com.esri.arcgisruntime.mapping.view.TimeExtentChangedListener
import com.esri.arcgisruntime.mapping.view.ViewpointChangedListener
import com.esri.arcgisruntime.util.ListenableList
import java.util.concurrent.ExecutionException
import java.util.concurrent.TimeUnit
import java.util.concurrent.TimeoutException

class FlutterMapView : FrameLayout, FlutterMapViewDelegate {
    private override val mapView: MapView
    private val viewpointChangedListeners = ArrayList<ViewpointChangedListener>()
    private val drawStatusChangedListeners = ArrayList<DrawStatusChangedListener>()
    private val layerViewStateChangedListeners = ArrayList<LayerViewStateChangedListener>()
    private val mapScaleChangedListeners = ArrayList<MapScaleChangedListener>()
    private val timeExtentChangedListeners = ArrayList<TimeExtentChangedListener>()
    private var isDisposed = false

    constructor(context: Context?, attrs: AttributeSet?) : super(context!!, attrs) {
        mapView = MapView(context)
        setupMapView()
    }

    constructor(context: Context?) : super(context!!) {
        mapView = MapView(context)
        setupMapView()
    }

    @Throws(Throwable::class)
    protected fun finalize() {
        dispose()
        super.finalize()
    }

    override fun dispose() {
        if (isDisposed) {
            return
        }
        isDisposed = true
        for (listener in viewpointChangedListeners) {
            mapView.removeViewpointChangedListener(listener)
        }
        viewpointChangedListeners.clear()
        for (listener in drawStatusChangedListeners) {
            mapView.removeDrawStatusChangedListener(listener)
        }
        drawStatusChangedListeners.clear()
        for (listener in layerViewStateChangedListeners) {
            mapView.removeLayerViewStateChangedListener(listener)
        }
        layerViewStateChangedListeners.clear()
        for (listener in mapScaleChangedListeners) {
            mapView.removeMapScaleChangedListener(listener)
        }
        mapScaleChangedListeners.clear()
        for (listener in timeExtentChangedListeners) {
            mapView.removeTimeExtentChangedListener(listener)
        }
        timeExtentChangedListeners.clear()
        mapView.dispose()
    }

    override fun resume() {
        if (isDisposed) {
            return
        }
        mapView.resume()
    }

    override fun pause() {
        if (isDisposed) {
            return
        }
        mapView.pause()
    }

    override fun getMapView(): MapView? {
        return if (isDisposed) null else mapView
    }

    override val selectionProperties: SelectionProperties?
        get() = if (isDisposed) {
            null
        } else mapView.selectionProperties
    override var map: ArcGISMap?
        get() = if (isDisposed) null else mapView.map
        set(map) {
            if (isDisposed) {
                return
            }
            mapView.map = map
        }
    override val interactionOptions: MapView.InteractionOptions?
        get() = if (isDisposed) null else mapView.interactionOptions

    override fun setAttributionTextVisible(visible: Boolean) {
        if (isDisposed) {
            return
        }
        mapView.isAttributionTextVisible = visible
    }

    override fun setViewInsets(left: Double, top: Double, right: Double, bottom: Double) {
        if (isDisposed) {
            return
        }
        mapView.setViewInsets(left, top, right, bottom)
    }

    override val mapScale: Double
        get() = if (isDisposed) {
            0
        } else try {
            mapView.mapScale
        } catch (e: Exception) {
            Log.e("FlutterMapView", "getMapScale", e)
            0
        }
    override val mapRotation: Double
        get() = if (isDisposed) {
            0
        } else try {
            mapView.mapRotation
        } catch (e: Exception) {
            Log.e("FlutterMapView", "getMapRotation", e)
            0
        }
    override val locationDisplay: LocationDisplay?
        get() = if (isDisposed) null else mapView.locationDisplay

    override fun exportImageAsync(): ListenableFuture<Bitmap?> {
        return if (isDisposed) ValueListenableFutureExt(null) else mapView.exportImageAsync()
    }

    override val graphicsOverlays: ListenableList<GraphicsOverlay?>?
        get() = if (isDisposed) null else mapView.graphicsOverlays

    override fun getCurrentViewpoint(type: Viewpoint.Type?): Viewpoint? {
        return if (isDisposed) null else mapView.getCurrentViewpoint(type)
    }

    override fun setViewpointAsync(viewpoint: Viewpoint?): ListenableFuture<Boolean?> {
        return if (isDisposed) ValueListenableFutureExt<Boolean>(false) else mapView.setViewpointAsync(
            viewpoint
        )
    }

    override fun setViewpointAsync(
        viewpoint: Viewpoint?,
        durationSeconds: Float
    ): ListenableFuture<Boolean?> {
        return if (isDisposed) ValueListenableFutureExt<Boolean>(false) else mapView.setViewpointAsync(
            viewpoint,
            durationSeconds
        )
    }

    override fun setViewpointGeometryAsync(geometry: Geometry?): ListenableFuture<Boolean?> {
        return if (isDisposed) ValueListenableFutureExt<Boolean>(false) else mapView.setViewpointGeometryAsync(
            geometry
        )
    }

    override fun setViewpointGeometryAsync(
        geometry: Geometry?,
        padding: Double
    ): ListenableFuture<Boolean?> {
        return if (isDisposed) ValueListenableFutureExt<Boolean>(false) else mapView.setViewpointGeometryAsync(
            geometry,
            padding
        )
    }

    override fun setViewpointCenterAsync(point: Point?, scale: Double): ListenableFuture<Boolean?> {
        return if (isDisposed) ValueListenableFutureExt<Boolean>(false) else mapView.setViewpointCenterAsync(
            point,
            scale
        )
    }

    override fun setViewpointScaleAsync(scale: Double): ListenableFuture<Boolean?> {
        return if (isDisposed) ValueListenableFutureExt<Boolean>(false) else mapView.setViewpointScaleAsync(
            scale
        )
    }

    override fun setViewpointRotationAsync(rotation: Double): ListenableFuture<Boolean?> {
        return if (isDisposed) ValueListenableFutureExt<Boolean>(false) else mapView.setViewpointRotationAsync(
            rotation
        )
    }

    override fun locationToScreen(point: Point?): android.graphics.Point? {
        return if (isDisposed) null else mapView.locationToScreen(point)
    }

    override fun screenToLocation(point: android.graphics.Point?): Point? {
        return if (isDisposed) null else mapView.screenToLocation(point)
    }

    override var timeExtent: TimeExtent?
        get() = if (isDisposed) null else mapView.timeExtent
        set(timeExtent) {
            if (isDisposed) {
                return
            }
            mapView.timeExtent = timeExtent
        }

    override fun addViewpointChangedListener(listener: ViewpointChangedListener) {
        if (isDisposed) {
            return
        }
        viewpointChangedListeners.add(listener)
        mapView.addViewpointChangedListener(listener)
    }

    override fun removeViewpointChangedListener(listener: ViewpointChangedListener) {
        if (isDisposed) {
            return
        }
        viewpointChangedListeners.remove(listener)
        mapView.removeViewpointChangedListener(listener)
    }

    override fun addDrawStatusChangedListener(listener: DrawStatusChangedListener) {
        if (isDisposed) {
            return
        }
        drawStatusChangedListeners.add(listener)
        mapView.addDrawStatusChangedListener(listener)
    }

    override fun removeDrawStatusChangedListener(listener: DrawStatusChangedListener) {
        if (isDisposed) {
            return
        }
        drawStatusChangedListeners.remove(listener)
        mapView.removeDrawStatusChangedListener(listener)
    }

    override fun addLayerViewStateChangedListener(listener: LayerViewStateChangedListener) {
        if (isDisposed) {
            return
        }
        layerViewStateChangedListeners.add(listener)
        mapView.addLayerViewStateChangedListener(listener)
    }

    override fun removeLayerViewStateChangedListener(listener: LayerViewStateChangedListener) {
        if (isDisposed) {
            return
        }
        layerViewStateChangedListeners.remove(listener)
        mapView.removeLayerViewStateChangedListener(listener)
    }

    override fun addMapScaleChangedListener(listener: MapScaleChangedListener) {
        if (isDisposed) {
            return
        }
        mapScaleChangedListeners.add(listener)
        mapView.addMapScaleChangedListener(listener)
    }

    override fun removeMapScaleChangedListener(listener: MapScaleChangedListener) {
        if (isDisposed) {
            return
        }
        mapScaleChangedListeners.remove(listener)
        mapView.removeMapScaleChangedListener(listener)
    }

    override fun addTimeExtentChangedListener(listener: TimeExtentChangedListener) {
        if (isDisposed) {
            return
        }
        timeExtentChangedListeners.add(listener)
        mapView.addTimeExtentChangedListener(listener)
    }

    override fun removeTimeExtentChangedListener(listener: TimeExtentChangedListener) {
        if (isDisposed) {
            return
        }
        timeExtentChangedListeners.remove(listener)
        mapView.removeTimeExtentChangedListener(listener)
    }

    private fun setupMapView() {
        addView(
            mapView, LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT
            )
        )
    }

    private inner class ValueListenableFutureExt<T>(private val value: T) : ListenableFuture<T> {
        override fun addDoneListener(runnable: Runnable) {
            runnable.run()
        }

        override fun removeDoneListener(runnable: Runnable): Boolean {
            return false
        }

        override fun cancel(b: Boolean): Boolean {
            return true
        }

        override fun isCancelled(): Boolean {
            return false
        }

        override fun isDone(): Boolean {
            return true
        }

        @Throws(ExecutionException::class, InterruptedException::class)
        override fun get(): T {
            return value
        }

        @Throws(ExecutionException::class, InterruptedException::class, TimeoutException::class)
        override fun get(l: Long, timeUnit: TimeUnit): T {
            return value
        }
    }
}