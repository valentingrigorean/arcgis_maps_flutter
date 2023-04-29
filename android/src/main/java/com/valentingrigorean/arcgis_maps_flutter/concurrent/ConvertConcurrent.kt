package com.valentingrigorean.arcgis_maps_flutter.concurrent

import com.arcgismaps.tasks.Job
import com.arcgismaps.tasks.JobMessage
import com.arcgismaps.tasks.JobMessageSeverity
import com.valentingrigorean.arcgis_maps_flutter.Convert

object ConvertConcurrent : Convert() {
    fun jobMessageToJson(message: JobMessage): Any {
        val json = HashMap<String, Any>(4)
        json["message"] = message.message
        json["severity"] = message.severity.ordinal
        json["source"] = message.source.ordinal
        json["timestamp"] =
            Convert.Companion.ISO8601Format.format(message.timestamp.time)
        return json
    }
}