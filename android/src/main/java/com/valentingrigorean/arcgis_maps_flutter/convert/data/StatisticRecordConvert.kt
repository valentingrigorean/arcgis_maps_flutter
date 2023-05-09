package com.valentingrigorean.arcgis_maps_flutter.convert.data

import com.arcgismaps.data.StatisticRecord

fun StatisticRecord.toFlutterJson(): Any {
    val data = HashMap<String, Any>()
    val group: MutableMap<String, Any> = mutableMapOf()

    this.group.forEach { (key, value) ->
        run {
            if (value is String || value is Int || value is Short || value is Double || value is Float) {
                group[key] = value
            }
        }
    }

    val statistics: MutableMap<String, Any> = mutableMapOf()

    this.statistics.forEach { (key, value) ->
        run {
            if (value is String || value is Int || value is Short || value is Double || value is Float) {
                statistics[key] = value
            }
        }
    }

    data["group"] = group
    data["statistics"] = statistics

    return data
}