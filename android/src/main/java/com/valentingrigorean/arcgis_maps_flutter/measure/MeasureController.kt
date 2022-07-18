package com.valentingrigorean.arcgis_maps_flutter.measure

import android.view.View
import com.esri.arcgisruntime.mapping.view.MapView
import io.flutter.plugin.common.MethodChannel

class MeasureController(
    arcMapView: MapView, containerView: View
) {

    private val distanceMeasure: ArcgisMeasureHelper = DistanceMeasureArcGisHelper(arcMapView,containerView)
    private val areaMeasure: ArcgisMeasureHelper = AreaMeasureHelper(arcMapView,containerView)

    fun onAreaMeasure(
        action: String,
        result: MethodChannel.Result
    ) {
        measure(measureHelper = areaMeasure, action = action, result = result)
    }

    fun onDistanceMeasure(
        action: String,
        result: MethodChannel.Result
    ) {
        measure(measureHelper = distanceMeasure, action = action, result = result)
    }

    private fun measure(
        measureHelper: ArcgisMeasureHelper, action: String,
        result: MethodChannel.Result
    ) {
        when (action) {
            "enter" -> {
                measureHelper.initMeasure()
                result.success(0.0)
//                measureHelper.forcePostFrame()
            }
            "makePoint" -> {
                result.success(measureHelper.makePoint())
//                measureHelper.forcePostFrame()
            }
            "revoke" -> {
                result.success(measureHelper.revoke())
//                measureHelper.forcePostFrame()
            }
            "clear" -> {
                result.success(measureHelper.clear())
//                measureHelper.forcePostFrame()
            }
            "exit" -> {
                measureHelper.reset()
                result.success(0.0)
//                measureHelper.forcePostFrame()
            }
            else -> {
                result.notImplemented()
            }
        }
    }
}