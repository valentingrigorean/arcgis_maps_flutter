package com.valentingrigorean.arcgis_maps_flutter.measure

import com.esri.arcgisruntime.mapping.view.MapView
import io.flutter.plugin.common.MethodChannel

class MeasureController(arcMapView: MapView) {

    private val distanceMeasure: ArcgisMeasureHelper = DistanceMeasureArcGisHelper(arcMapView)
    private val areaMeasure: ArcgisMeasureHelper = AreaMeasureHelper(arcMapView)

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
            }
            "makePoint" -> {
                result.success(measureHelper.makePoint())
            }
            "revoke" -> {
                result.success(measureHelper.revoke())
            }
            "clear" -> {
                result.success(measureHelper.clear())
            }
            "exit" -> {
                measureHelper.reset()
                result.success(0.0)
            }
            else -> {
                result.notImplemented()
            }
        }
    }
}