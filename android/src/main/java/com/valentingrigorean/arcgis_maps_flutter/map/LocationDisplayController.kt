package com.valentingrigorean.arcgis_maps_flutter.map

import com.esri.arcgisruntime.ArcGISRuntimeException
import com.esri.arcgisruntime.mapping.view.Graphic
import com.esri.arcgisruntime.mapping.view.GraphicsOverlay
import com.esri.arcgisruntime.mapping.view.LocationDisplay
import com.esri.arcgisruntime.mapping.view.LocationDisplay.AutoPanModeChangedEvent
import com.esri.arcgisruntime.mapping.view.LocationDisplay.AutoPanModeChangedListener
import com.esri.arcgisruntime.mapping.view.LocationDisplay.DataSourceStatusChangedEvent
import com.esri.arcgisruntime.mapping.view.LocationDisplay.DataSourceStatusChangedListener
import com.valentingrigorean.arcgis_maps_flutter.Convert
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class LocationDisplayController(
    private val channel: MethodChannel,
    private val flutterMapViewDelegate: FlutterMapViewDelegate
) : MapTouchGraphicDelegate, LocationDisplay.LocationChangedListener, MethodCallHandler,
    AutoPanModeChangedListener, DataSourceStatusChangedListener {
    private val locationDisplay: LocationDisplay?
    private val locationGraphicsOverlay: GraphicsOverlay
    private val locationGraphic: Graphic
    private var delegate: LocationDisplayControllerDelegate? = null
    private var startResult: MethodChannel.Result? = null
    private var trackUserLocationTap = false

    init {
        locationDisplay = flutterMapViewDelegate.locationDisplay
        locationGraphicsOverlay = GraphicsOverlay()
        locationGraphicsOverlay.opacity = 0f
        locationGraphic = Graphic()
        locationGraphic.geometry = flutterMapViewDelegate.locationDisplay.mapLocation
        locationGraphic.attributes[LOCATION_ATTRIBUTE] = true
        locationGraphic.symbol = locationDisplay!!.defaultSymbol
        locationGraphicsOverlay.graphics.add(locationGraphic)
        channel.setMethodCallHandler(this)
        locationDisplay.addDataSourceStatusChangedListener(this)
        locationDisplay.addAutoPanModeChangedListener(this)
        locationDisplay.addLocationChangedListener(this)
    }

    fun dispose() {
        locationDisplay!!.removeDataSourceStatusChangedListener(this)
        locationDisplay.removeAutoPanModeChangedListener(this)
        locationDisplay.removeLocationChangedListener(this)
        if (startResult != null) {
            startResult!!.success(null)
            startResult = null
        }
        channel.setMethodCallHandler(null)
    }

    fun setTrackUserLocationTap(trackUserLocationTap: Boolean) {
        if (this.trackUserLocationTap != trackUserLocationTap) {
            this.trackUserLocationTap = trackUserLocationTap
            if (trackUserLocationTap) {
                flutterMapViewDelegate.graphicsOverlays.add(locationGraphicsOverlay)
            } else {
                flutterMapViewDelegate.graphicsOverlays.remove(locationGraphicsOverlay)
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

    override fun onStatusChanged(dataSourceStatusChangedEvent: DataSourceStatusChangedEvent) {
        try {
            locationGraphic.geometry = locationDisplay!!.mapLocation
        } catch (e: ArcGISRuntimeException) {
            //ignore
        }
        handleStatusChanged(
            dataSourceStatusChangedEvent.isStarted,
            dataSourceStatusChangedEvent.error
        )
    }

    override fun onAutoPanModeChanged(autoPanModeChangedEvent: AutoPanModeChangedEvent) {
        channel.invokeMethod("onAutoPanModeChanged", autoPanModeChangedEvent.autoPanMode.ordinal)
    }

    override fun onLocationChanged(locationChangedEvent: LocationDisplay.LocationChangedEvent) {
        try {
            locationGraphic.geometry = locationDisplay!!.mapLocation
        } catch (e: ArcGISRuntimeException) {
            //ignore
        }
        channel.invokeMethod(
            "onLocationChanged",
            Convert.Companion.locationToJson(locationChangedEvent.location)
        )
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getStarted" -> result.success(locationDisplay!!.isStarted)
            "setAutoPanMode" -> {
                locationDisplay!!.autoPanMode =
                    Convert.Companion.toAutoPanMode(call.arguments)
                result.success(null)
            }

            "setInitialZoomScale" -> {
                locationDisplay!!.initialZoomScale = call.arguments()!!
                result.success(null)
            }

            "setNavigationPointHeightFactor" -> {
                locationDisplay!!.navigationPointHeightFactor = call.arguments()!!
                result.success(null)
            }

            "setWanderExtentFactor" -> {
                locationDisplay!!.wanderExtentFactor = call.arguments()!!
                result.success(null)
            }

            "getLocation" -> if (locationDisplay!!.location != null) {
                result.success(
                    Convert.Companion.locationToJson(
                        locationDisplay.location
                    )
                )
            } else {
                result.success(null)
            }

            "getMapLocation" -> if (locationDisplay!!.mapLocation != null) {
                result.success(
                    Convert.Companion.geometryToJson(
                        locationDisplay.mapLocation
                    )
                )
            } else {
                result.success(null)
            }

            "getHeading" -> result.success(locationDisplay!!.heading)
            "setUseCourseSymbolOnMovement" -> {
                locationDisplay!!.isUseCourseSymbolOnMovement = call.arguments()!!
                result.success(null)
            }

            "setOpacity" -> {
                locationDisplay!!.opacity = call.arguments()!!
                result.success(null)
            }

            "setShowAccuracy" -> {
                locationDisplay!!.isShowAccuracy = call.arguments()!!
                result.success(null)
            }

            "setShowLocation" -> locationDisplay!!.isShowLocation = call.arguments()!!
            "setShowPingAnimationSymbol" -> {
                locationDisplay!!.isShowPingAnimation = call.arguments()!!
                result.success(null)
            }

            "start" -> {
                startResult = result
                locationDisplay!!.startAsync()
            }

            "stop" -> {
                locationDisplay!!.stop()
                result.success(null)
            }

            else -> result.notImplemented()
        }
    }

    private fun handleStatusChanged(
        isStarted: Boolean,
        error: Throwable?
    ) {
        if (startResult != null) {
            if (isStarted) {
                startResult!!.success(null)
            } else {
                var errorMessage: String? = "Unknown error"
                if (error != null) {
                    errorMessage = error.message
                }
                startResult!!.error("Failed to start locationDisplay", errorMessage, null)
            }
            startResult = null
        }
    }

    interface LocationDisplayControllerDelegate {
        fun onUserLocationTap()
    }

    companion object {
        private const val LOCATION_ATTRIBUTE = "my_location_attribute"
    }
}