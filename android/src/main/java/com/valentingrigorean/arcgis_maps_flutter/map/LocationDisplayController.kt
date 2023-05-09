package com.valentingrigorean.arcgis_maps_flutter.map

import com.arcgismaps.location.LocationDataSourceStatus
import com.arcgismaps.mapping.view.GeoView
import com.arcgismaps.mapping.view.Graphic
import com.arcgismaps.mapping.view.GraphicsOverlay
import com.arcgismaps.mapping.view.LocationDisplay
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toGeometryOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.location.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.convert.location.toFlutterValue
import com.valentingrigorean.arcgis_maps_flutter.convert.location.toLocationDisplayAutoPanMode
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.launch

class LocationDisplayController(
    private val channel: MethodChannel,
    private val locationDisplay: LocationDisplay,
    private val geoView: GeoView,
    private val scope: CoroutineScope
) : MapTouchGraphicDelegate, MethodCallHandler {
    private val locationGraphicsOverlay = GraphicsOverlay()
    private val locationGraphic: Graphic
    private var delegate: LocationDisplayControllerDelegate? = null
    private var trackUserLocationTap = false

    init {
        locationGraphicsOverlay.opacity = 0f
        locationGraphic = Graphic()
        locationGraphic.geometry = locationDisplay.mapLocation
        locationGraphic.attributes[LOCATION_ATTRIBUTE] = true
        locationGraphic.symbol = locationDisplay.defaultSymbol
        locationGraphicsOverlay.graphics.add(locationGraphic)
        channel.setMethodCallHandler(this)
        locationDisplay.autoPanMode.onEach {
            channel.invokeMethod("onAutoPanModeChanged", it.toFlutterValue())
        }.launchIn(scope)
        locationDisplay.location.onEach {
            locationGraphic.geometry = locationDisplay.mapLocation
            channel.invokeMethod(
                "onLocationChanged",
                it?.toFlutterJson()
            )
        }.launchIn(scope)

        locationDisplay.dataSource.status.onEach {
            locationGraphic.geometry = locationDisplay.mapLocation
        }.launchIn(scope)
    }

    fun dispose() {
        channel.setMethodCallHandler(null)
    }

    fun setTrackUserLocationTap(trackUserLocationTap: Boolean) {
        if (this.trackUserLocationTap != trackUserLocationTap) {
            this.trackUserLocationTap = trackUserLocationTap
            if (trackUserLocationTap) {
                geoView.graphicsOverlays.add(locationGraphicsOverlay)
            } else {
                geoView.graphicsOverlays.remove(locationGraphicsOverlay)
            }
        }
    }

    fun setLocationDisplayControllerDelegate(delegate: LocationDisplayControllerDelegate?) {
        this.delegate = delegate
    }

    override fun canConsumeTaps(): Boolean {
        return trackUserLocationTap
    }

    override fun didHandleGraphic(graphic: Graphic): Boolean {
        val result = graphic.attributes.containsKey(LOCATION_ATTRIBUTE)
        if (result && delegate != null) {
            delegate!!.onUserLocationTap()
        }
        return result
    }


    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getStarted" -> result.success(locationDisplay.dataSource.status.value == LocationDataSourceStatus.Started)
            "setAutoPanMode" -> {
                locationDisplay.setAutoPanMode((call.arguments as Int).toLocationDisplayAutoPanMode())
                result.success(null)
            }

            "setInitialZoomScale" -> {
                locationDisplay.initialZoomScale = call.arguments()!!
                result.success(null)
            }

            "setNavigationPointHeightFactor" -> {
                locationDisplay.navigationPointHeightFactor = call.arguments()!!
                result.success(null)
            }

            "setWanderExtentFactor" -> {
                locationDisplay.wanderExtentFactor = call.arguments()!!
                result.success(null)
            }

            "getLocation" -> {
                result.success(
                    locationDisplay.location.value?.toFlutterJson()
                )
            }

            "getMapLocation" -> {
                result.success(
                    locationDisplay.location.value?.toGeometryOrNull()
                )
            }

            "getHeading" -> result.success(locationDisplay.heading)
            "setUseCourseSymbolOnMovement" -> {
                locationDisplay.useCourseSymbolOnMovement = call.arguments()!!
                result.success(null)
            }

            "setOpacity" -> {
                locationDisplay.opacity = call.arguments()!!
                result.success(null)
            }

            "setShowAccuracy" -> {
                locationDisplay.showAccuracy = call.arguments()!!
                result.success(null)
            }

            "setShowLocation" -> {
                locationDisplay.showLocation = call.arguments()!!
                result.success(null)
            }
            "setShowPingAnimationSymbol" -> {
                locationDisplay.showPingAnimationSymbol = call.arguments()!!
                result.success(null)
            }

            "start" -> {
                 scope.launch {
                     locationDisplay.dataSource.start().onSuccess {
                         result.success(null)
                     }.onFailure {
                         result.error("Failed to start locationDisplay", it.message, null)
                     }
                 }
            }

            "stop" -> {
                scope.launch {
                    locationDisplay.dataSource.stop()
                    result.success(null)
                }
            }

            else -> result.notImplemented()
        }
    }

    interface LocationDisplayControllerDelegate {
        fun onUserLocationTap()
    }

    companion object {
        private const val LOCATION_ATTRIBUTE = "my_location_attribute"
    }
}