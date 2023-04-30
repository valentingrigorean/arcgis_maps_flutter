package com.valentingrigorean.arcgis_maps_flutter.convert.tasks

import com.arcgismaps.tasks.JobMessageSeverity
import com.arcgismaps.tasks.JobMessageSource
import com.arcgismaps.tasks.JobStatus

fun JobMessageSeverity.toFlutterValue() {
    when (this) {
        JobMessageSeverity.Info -> 0
        JobMessageSeverity.Warning -> 1
        JobMessageSeverity.Error -> 2
    }
}

fun JobMessageSource.toFlutterValue() {
    when (this) {
        JobMessageSource.Client -> 0
        JobMessageSource.Service -> 1
    }
}

fun JobStatus.toFlutterValue() {
    when (this) {
        JobStatus.NotStarted -> 0
        JobStatus.Started -> 1
        JobStatus.Paused -> 2
        JobStatus.Succeeded -> 3
        JobStatus.Failed -> 4
        JobStatus.Canceling -> 5
    }
}