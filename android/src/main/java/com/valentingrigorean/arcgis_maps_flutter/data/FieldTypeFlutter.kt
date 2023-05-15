package com.valentingrigorean.arcgis_maps_flutter.data

import android.icu.text.SimpleDateFormat
import com.arcgismaps.geometry.Geometry
import com.valentingrigorean.arcgis_maps_flutter.convert.fromFlutterInstant
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toGeometryOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterValue
import java.nio.ByteBuffer
import java.time.Instant
import java.util.GregorianCalendar
import java.util.Locale
import java.util.UUID

enum class FieldTypeFlutter(val value: Int) {
    UNKNOWN(0), INTEGER(1), DOUBLE(2), DATE(3), TEXT(4), NULLABLE(5), BLOB(6), GEOMETRY(7);
}

private val ISO8601Format = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSXXX", Locale.US)
fun Any.toFlutterFieldType(): Any {
    val data: MutableMap<String, Any?> = HashMap(2)
    val fieldTypeFlutter: FieldTypeFlutter
    var obj = this
    if (this is String) {
        fieldTypeFlutter = FieldTypeFlutter.TEXT
    } else if (obj is Short || obj is Int) {
        fieldTypeFlutter = FieldTypeFlutter.INTEGER
    } else if (obj is Float || obj is Double) {
        fieldTypeFlutter = FieldTypeFlutter.DOUBLE
    } else if (obj is GregorianCalendar) {
        fieldTypeFlutter = FieldTypeFlutter.DATE
        obj = ISO8601Format.format(
            obj.time
        )
    } else if (obj is Instant) {
        fieldTypeFlutter = FieldTypeFlutter.DATE
        obj = obj.toFlutterValue()
    } else if (obj is UUID) {
        fieldTypeFlutter = FieldTypeFlutter.TEXT
        obj = obj.toString()
    } else if (obj is ByteArray || obj is ByteBuffer) {
        fieldTypeFlutter = FieldTypeFlutter.BLOB
        if (obj is ByteBuffer) {
            obj = obj.array()
        }
    } else if (obj is Geometry) {
        fieldTypeFlutter = FieldTypeFlutter.GEOMETRY
        obj = obj.toFlutterJson()!!
    } else if (obj == null) {
        fieldTypeFlutter = FieldTypeFlutter.NULLABLE
    } else {
        fieldTypeFlutter = FieldTypeFlutter.UNKNOWN
        obj = obj.toString()
    }
    data["type"] = fieldTypeFlutter.value
    data["value"] = obj
    return data
}

fun Any.fromFlutterFieldOrNull(): Any? {
    val data: Map<*, *> = this as Map<*, *>? ?: return null
    val fieldTypeFlutter = FieldTypeFlutter.values()[ConvertUti.toInt(
        data["type"]
    )]
    var value = data["value"]
    when (fieldTypeFlutter) {
        FieldTypeFlutter.DATE -> try {
            value = value.toString().fromFlutterInstant()
        } catch (e: Exception) {
            // no op
        }

        FieldTypeFlutter.GEOMETRY -> if (value != null) {
            value = value.toGeometryOrNull()
        }

        else -> {}
    }
    return value
}