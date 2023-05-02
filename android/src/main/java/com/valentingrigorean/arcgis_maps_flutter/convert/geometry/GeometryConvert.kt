package com.valentingrigorean.arcgis_maps_flutter.convert.geometry

import com.arcgismaps.geometry.Envelope
import com.arcgismaps.geometry.Geometry
import com.arcgismaps.geometry.Multipoint
import com.arcgismaps.geometry.Point
import com.arcgismaps.geometry.Polygon
import com.arcgismaps.geometry.Polyline
import com.valentingrigorean.arcgis_maps_flutter.Convert
import com.valentingrigorean.arcgis_maps_flutter.convert.toMap
import org.json.JSONObject
import java.lang.Exception


fun Any.toPointOrNull(): Point? {
    val data: Map<*, *> = this as Map<*, *>? ?: return null
    val x = data["x"] as Double
    val y = data["y"] as Double
    var z: Double? = null
    var m: Double? = null
    if (data.containsKey("z")) z = data["z"] as Double
    if (data.containsKey("m")) m = data["m"] as Double
    val spatialReference = (data["spatialReference"] as Map<*, *>?)?.toSpatialReferenceOrNull()
    return Point(x, y, z, m, spatialReference)
}

fun Any.toEnvelopeOrNull(): Envelope? {
    val data: Map<*, *> = this as Map<*, *>? ?: return null
    val spatialReference = data["spatialReference"]?.toSpatialReferenceOrNull()

    if (data.containsKey("xmin")) {
        val xmin = Convert.toDouble(
            data["xmin"]
        )
        val ymin = Convert.toDouble(
            data["ymin"]
        )
        val xmax = Convert.toDouble(
            data["xmax"]
        )
        val ymax = Convert.toDouble(
            data["ymax"]
        )
        return Envelope(xmin, ymin, xmax, ymax, null, null, null, null, spatialReference)
    }
    if (data.containsKey("bbox")) {
        val bbox = Convert.toDoubleArray(
            data["bbox"]
        )
        return Envelope(
            bbox!![0],
            bbox[1],
            bbox[2],
            bbox[3],
            null,
            null,
            null,
            null,
            spatialReference
        )
    }
    return null
}


fun Any.toGeometryOrNull(): Geometry? {
    if (this is String) {
        return Geometry.fromJsonOrNull(this)
    }

    if (this is Map<*, *>) {
        return when (this["geometryType"] as Int) {
            1 -> this.toPointOrNull()
            2 -> this.toEnvelopeOrNull()
            3, 4, 5 -> {
                val json = JSONObject(this)
                return Geometry.fromJsonOrNull(json.toString())
            }

            else -> throw IllegalArgumentException("Invalid geometry")
        }
    }

    throw IllegalArgumentException("Invalid geometry")
}


fun Geometry.toFlutterJson(): Any? {
    val sb = StringBuilder(toJson())
    /// account for empty geometries
    if (sb.length > 2) {
        val geometryType = ",\"type\":" + geometryType()
        sb.insert(sb.length - 1, geometryType)
    }
    try {
        return JSONObject(sb.toString()).toMap()
    } catch (e: Exception) {
        e.printStackTrace()
    }
    return null
}


private fun Geometry.geometryType(): Int {
    return when (this) {
        is Point -> 1
        is Envelope -> 2
        is Polyline -> 3
        is Polygon -> 4
        is Multipoint -> 5
        else -> -1
    }
}