package com.valentingrigorean.arcgis_maps_flutter.geometry

import com.arcgismaps.geometry.CoordinateFormatter
import com.arcgismaps.geometry.Point
import com.valentingrigorean.arcgis_maps_flutter.Convert
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class CoordinateFormatterController(messenger: BinaryMessenger) : MethodCallHandler {
    private val channel: MethodChannel

    init {
        channel =
            MethodChannel(messenger, "plugins.flutter.io/arcgis_channel/coordinate_formatter")
        channel.setMethodCallHandler(this)
    }

    fun dispose() {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "latitudeLongitudeString" -> {
                val data: Map<*, *> = Convert.Companion.toMap(call.arguments)
                val from = Convert.Companion.toGeometry(
                    data["from"]
                ) as Point
                val format: Int = Convert.Companion.toInt(
                    data["format"]
                )
                val decimalPlaces: Int = Convert.Companion.toInt(
                    data["decimalPlaces"]
                )
                result.success(
                    CoordinateFormatter.fromLatitudeLongitudeOrNull(
                        from,
                        CoordinateFormatter.LatitudeLongitudeFormat.values()[format],
                        decimalPlaces
                    )
                )
            }

            else -> result.notImplemented()
        }
    }

    companion object {
        private const val TAG = "CoordinateFormatterController"
    }
}