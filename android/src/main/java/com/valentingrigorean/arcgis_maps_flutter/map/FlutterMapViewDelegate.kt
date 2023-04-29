package com.valentingrigorean.arcgis_maps_flutter.map

import android.graphics.Bitmap
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

interface FlutterMapViewDelegate {
    fun dispose()
    fun resume()
    fun pause()
    val mapView: MapView?
    val selectionProperties: SelectionProperties?
    var map: ArcGISMap?
    val interactionOptions: MapView.InteractionOptions?
    fun setAttributionTextVisible(visible: Boolean)
    fun setViewInsets(left: Double, top: Double, right: Double, bottom: Double)
    val mapScale: Double
    val mapRotation: Double
    val locationDisplay: LocationDisplay?
    fun exportImageAsync(): ListenableFuture<Bitmap?>
    val graphicsOverlays: ListenableList<GraphicsOverlay?>?
    fun getCurrentViewpoint(type: Viewpoint.Type?): Viewpoint?
    fun setViewpointAsync(viewpoint: Viewpoint?): ListenableFuture<Boolean?>
    fun setViewpointAsync(viewpoint: Viewpoint?, durationSeconds: Float): ListenableFuture<Boolean?>
    fun setViewpointGeometryAsync(geometry: Geometry?): ListenableFuture<Boolean?>
    fun setViewpointGeometryAsync(geometry: Geometry?, padding: Double): ListenableFuture<Boolean?>
    fun setViewpointCenterAsync(point: Point?, scale: Double): ListenableFuture<Boolean?>
    fun setViewpointScaleAsync(scale: Double): ListenableFuture<Boolean?>
    fun setViewpointRotationAsync(rotation: Double): ListenableFuture<Boolean?>
    fun locationToScreen(point: Point?): android.graphics.Point?
    fun screenToLocation(point: android.graphics.Point?): Point?
    var timeExtent: TimeExtent?
    fun addViewpointChangedListener(listener: ViewpointChangedListener)
    fun removeViewpointChangedListener(listener: ViewpointChangedListener)
    fun addDrawStatusChangedListener(listener: DrawStatusChangedListener)
    fun removeDrawStatusChangedListener(listener: DrawStatusChangedListener)
    fun addLayerViewStateChangedListener(listener: LayerViewStateChangedListener)
    fun removeLayerViewStateChangedListener(listener: LayerViewStateChangedListener)
    fun addMapScaleChangedListener(listener: MapScaleChangedListener)
    fun removeMapScaleChangedListener(listener: MapScaleChangedListener)
    fun addTimeExtentChangedListener(listener: TimeExtentChangedListener)
    fun removeTimeExtentChangedListener(listener: TimeExtentChangedListener)
}