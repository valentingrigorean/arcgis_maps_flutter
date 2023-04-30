package com.valentingrigorean.arcgis_maps_flutter.tasks.geodatabase

import com.arcgismaps.tasks.geodatabase.GenerateGeodatabaseJob
import com.valentingrigorean.arcgis_maps_flutter.concurrent.JobNativeHandler
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeMessageSink

class GenerateGeodatabaseJobNativeObject(
    objectId: String,
    job: GenerateGeodatabaseJob,
    messageSink: NativeMessageSink
) : BaseNativeObject<GenerateGeodatabaseJob>(
    objectId, job, arrayOf(
        JobNativeHandler(job, JobNativeHandler.JobType.GENERATE_GEODATABASE)
    )
) {
    init {
        setMessageSink(messageSink)
    }
}