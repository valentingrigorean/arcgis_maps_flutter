package com.valentingrigorean.arcgis_maps_flutter.geometry

import com.arcgismaps.geometry.CoordinateFormatter
import com.arcgismaps.geometry.GeodesicSectorParameters
import com.arcgismaps.geometry.Point
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toGeometryOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toLatitudeLongitudeFormat
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
                val data = call.arguments as Map<*, *>
                val from =  data["from"]?.toGeometryOrNull()!! as Point
                val format = (data["format"] as Int).toLatitudeLongitudeFormat()
                val decimalPlaces = data["decimalPlaces"] as Int
                result.success(
                    CoordinateFormatter.toLatitudeLongitudeOrNull(
                        from,
                        format,
                        decimalPlaces
                    )
                )
            }

            else -> result.notImplemented()
        }
    }
}