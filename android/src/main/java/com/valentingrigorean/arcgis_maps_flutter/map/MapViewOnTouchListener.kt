package com.valentingrigorean.arcgis_maps_flutter.map

import android.util.Log
import com.arcgismaps.geometry.Point
import com.arcgismaps.mapping.view.IdentifyGraphicsOverlayResult
import com.arcgismaps.mapping.view.MapView
import com.arcgismaps.mapping.view.ScreenCoordinate
import com.valentingrigorean.arcgis_maps_flutter.Convert
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toFlutterJson
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.launch

private enum class MessageType {
    OnTap,
    OnLongPress,
    OnLongPressEnd,
}

class MapViewOnTouchListener(
    private val mapView: MapView,
    private val methodChannel: MethodChannel,
    private val scope: CoroutineScope,
) {
    private val mapTouchGraphicDelegates = ArrayList<MapTouchGraphicDelegate>()
    private var graphicJob: Job? = null
    private var layerJob: Job? = null
    private val isLongPress = false
    var trackIdentityLayers = false


    init {
        mapView.onSingleTapConfirmed.onEach {
            clearHandlers()
            if (mapView.map == null) {
                return@onEach
            }

            if (canConsumeGraphics()) {
                Log.d(TAG, "onSingleTapConfirmed: identifyGraphicsOverlays")
                identifyGraphicsOverlays(it.screenCoordinate)
            } else if (trackIdentityLayers) {
                Log.d(TAG, "onSingleTapConfirmed: identifyLayers")
                identifyLayers(it.mapPoint)
            } else {
                sendOnMapTap(it.screenCoordinate)
            }
        }.launchIn(scope)

        mapView.onLongPress.onEach {

        }.launchIn(scope)
    }

    fun addGraphicDelegate(mapTouchGraphicDelegate: MapTouchGraphicDelegate) {
        if (!mapTouchGraphicDelegates.contains(mapTouchGraphicDelegate)) mapTouchGraphicDelegates.add(
            mapTouchGraphicDelegate
        )
    }

    fun clearAllDelegates() {
        mapTouchGraphicDelegates.clear()
    }


    private fun identifyGraphicsOverlays(screenPoint: ScreenCoordinate, point: Point?) {
        graphicJob = scope.launch {
            mapView.identifyGraphicsOverlays(screenPoint, 10.0, false, 10).onSuccess {
                if (onTapCompleted(it)) {
                    return@launch
                }
                if (trackIdentityLayers) {
                    identifyLayers(screenPoint, point)
                } else {
                    sendMessage(screenPoint, point, MessageType.OnTap)
                }
            }
        }
    }

    private fun identifyLayers(screenPoint: ScreenCoordinate, point: Point?) {
        layerJob = scope.launch {
            mapView.identifyLayers(screenPoint, 10.0, false, 10).onSuccess {
                if (it.isEmpty()) {
                    sendMessage(screenPoint, point, MessageType.OnTap)
                    return@launch
                }
            }
        }
    }

    private fun onTapCompleted(
        results: List<IdentifyGraphicsOverlayResult>,
    ): Boolean {

        for (result in results) {
            for (touchDelegate in mapTouchGraphicDelegates) {
                for (graphic in result.graphics) {
                    if (touchDelegate.didHandleGraphic(graphic)) {
                        return true
                    }
                }
            }
        }
        return false
    }

    private fun sendMessage(
        screenPoint: ScreenCoordinate,
        point: Point?,
        messageType: MessageType
    ) {
        val data = HashMap<String, Any?>(2)
        data["position"] = point?.toFlutterJson()
        data["screenPoint"] = arrayListOf(screenPoint.x, screenPoint.y)
        when (messageType) {
            MessageType.OnTap -> methodChannel.invokeMethod("map#onTap", data)
            MessageType.OnLongPress -> methodChannel.invokeMethod("map#onLongPress", data)
            MessageType.OnLongPressEnd -> methodChannel.invokeMethod("map#onLongPressEnd", data)
        }
    }

    private fun clearHandlers() {
        graphicJob?.cancel()
        graphicJob = null
        layerJob?.cancel()
        layerJob = null
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