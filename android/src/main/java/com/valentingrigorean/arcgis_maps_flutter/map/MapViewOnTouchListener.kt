package com.valentingrigorean.arcgis_maps_flutter.map

import android.content.Context
import android.graphics.Point
import android.util.Log
import android.view.MotionEvent
import com.arcgismaps.mapping.view.IdentifyGraphicsOverlayResult
import com.valentingrigorean.arcgis_maps_flutter.Convert
import io.flutter.plugin.common.MethodChannel

class MapViewOnTouchListener(
    context: Context?,
    private val flutterMapViewDelegate: FlutterMapViewDelegate,
    private val methodChannel: MethodChannel
) : DefaultMapViewOnTouchListener(context, flutterMapViewDelegate.mapView) {
    private val mapTouchGraphicDelegates = ArrayList<MapTouchGraphicDelegate>()
    private var graphicHandler: ListenableFuture<List<IdentifyGraphicsOverlayResult>>? = null
    private var layerHandler: ListenableFuture<List<IdentifyLayerResult>>? = null
    private var trackIdentityLayers = false
    private var isLongPress = false
    fun setTrackIdentityLayers(trackIdentityLayers: Boolean) {
        this.trackIdentityLayers = trackIdentityLayers
    }

    fun addGraphicDelegate(mapTouchGraphicDelegate: MapTouchGraphicDelegate) {
        if (!mapTouchGraphicDelegates.contains(mapTouchGraphicDelegate)) mapTouchGraphicDelegates.add(
            mapTouchGraphicDelegate
        )
    }

    fun clearAllDelegates() {
        mapTouchGraphicDelegates.clear()
    }

    override fun onSingleTapConfirmed(e: MotionEvent): Boolean {
        clearHandlers()
        if (flutterMapViewDelegate.mapView == null) {
            return false
        }
        try {
            val screenPoint = Point(e.x.toInt(), e.y.toInt())
            if (canConsumeGraphics()) {
                Log.d(TAG, "onSingleTapConfirmed: identifyGraphicsOverlays")
                identifyGraphicsOverlays(screenPoint)
            } else if (trackIdentityLayers) {
                Log.d(TAG, "onSingleTapConfirmed: identifyLayers")
                identifyLayers(screenPoint)
            } else {
                sendOnMapTap(screenPoint)
            }
            return true
        } catch (ex: Exception) {
            Log.e(TAG, "onSingleTapConfirmed: ", ex)
        }
        return false
    }

    override fun onLongPress(e: MotionEvent) {
        try {
            super.onLongPress(e)
            val screenPoint = Point(e.x.toInt(), e.y.toInt())
            sendOnMapLongPress(screenPoint, false)
            isLongPress = true
        } catch (exception: Exception) {
            Log.e(TAG, "onLongPress: ", exception)
        }
    }

    override fun onUp(e: MotionEvent): Boolean {
        if (isLongPress) {
            try {
                super.onUp(e)
                val screenPoint = Point(e.x.toInt(), e.y.toInt())
                sendOnMapLongPress(screenPoint, true)
                isLongPress = false
            } catch (exception: Exception) {
                Log.e(TAG, "onLongPressEnd: ", exception)
            }
        }
        return true
    }

    private fun identifyGraphicsOverlays(screenPoint: Point) {
        val mapView = flutterMapViewDelegate.mapView ?: return
        graphicHandler = mapView.identifyGraphicsOverlaysAsync(screenPoint, 12.0, false)
        graphicHandler.addDoneListener(Runnable {
            try {
                val results = graphicHandler.get()
                graphicHandler = null
                Log.d(TAG, "identifyGraphicsOverlays: " + results.size + " found.")
                if (onTapCompleted(results, screenPoint)) {
                    return@addDoneListener
                }
                if (trackIdentityLayers) {
                    identifyLayers(screenPoint)
                } else {
                    sendOnMapTap(screenPoint)
                }
            } catch (ex: Exception) {
                ex.printStackTrace()
            }
        })
    }

    private fun identifyLayers(screenPoint: Point) {
        val mapView = flutterMapViewDelegate.mapView ?: return
        layerHandler = mapView.identifyLayersAsync(screenPoint, 10.0, false)
        layerHandler.addDoneListener(Runnable {
            try {
                val results = layerHandler.get()
                layerHandler = null
                Log.d(TAG, "identifyLayers: " + results.size + " found.")
                if (results.size == 0) {
                    sendOnMapTap(screenPoint)
                    return@addDoneListener
                }
                val jsonResults: Any = Convert.Companion.identifyLayerResultsToJson(results)
                val position = mMapView.screenToLocation(screenPoint)
                val data = HashMap<String, Any?>(3)
                data["results"] = jsonResults
                data["screenPoint"] = Convert.Companion.pointToJson(screenPoint)
                data["position"] = Convert.Companion.geometryToJson(position)
                methodChannel.invokeMethod("map#onIdentifyLayers", data)
            } catch (ex: Exception) {
                ex.printStackTrace()
            }
        })
    }

    private fun onTapCompleted(
        results: List<IdentifyGraphicsOverlayResult>?,
        screenPoint: Point
    ): Boolean {
        if (results != null) {
            for (result in results) {
                for (touchDelegate in mapTouchGraphicDelegates) {
                    for (graphic in result.graphics) {
                        if (touchDelegate.didHandleGraphic(graphic)) {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }

    private fun sendOnMapTap(screenPoint: Point) {
        val mapView = flutterMapViewDelegate.mapView ?: return
        val mapPoint = mapView.screenToLocation(screenPoint) ?: return
        val data = HashMap<String, Any?>(1)
        data["position"] = Convert.Companion.geometryToJson(mapPoint)
        data["screenPoint"] =
            Convert.Companion.pointToJson(screenPoint)
        methodChannel.invokeMethod("map#onTap", data)
    }

    private fun sendOnMapLongPress(screenPoint: Point, isEnd: Boolean) {
        val mapView = flutterMapViewDelegate.mapView ?: return
        val mapPoint = mapView.screenToLocation(screenPoint) ?: return
        val data = HashMap<String, Any?>(1)
        data["position"] =
            Convert.Companion.geometryToJson(mapPoint)
        data["screenPoint"] = Convert.Companion.pointToJson(screenPoint)
        if (isEnd) {
            methodChannel.invokeMethod("map#onLongPressEnd", data)
        } else {
            methodChannel.invokeMethod("map#onLongPress", data)
        }
    }

    private fun clearHandlers() {
        if (graphicHandler != null) {
            graphicHandler!!.cancel(true)
            graphicHandler = null
        }
        if (layerHandler != null) {
            layerHandler!!.cancel(true)
            layerHandler = null
        }
    }

    private fun canConsumeGraphics(): Boolean {
        for (touchDelegate in mapTouchGraphicDelegates) {
            if (touchDelegate.canConsumeTaps()) {
                return true
            }
        }
        return false
    }

    companion object {
        private const val TAG = "MapViewOnTouchListener"
    }
}