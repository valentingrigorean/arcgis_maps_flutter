package com.valentingrigorean.arcgis_maps_flutter.tasks.geodatabase

import com.esri.arcgisruntime.tasks.geodatabase.GenerateGeodatabaseJob
import com.valentingrigorean.arcgis_maps_flutter.concurrent.JobNativeHandler
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeMessageSink

class GenerateGeodatabaseJobNativeObject(
    objectId: String?,
    job: GenerateGeodatabaseJob,
    messageSink: NativeMessageSink?
) : BaseNativeObject<GenerateGeodatabaseJob?>(
    objectId, job, arrayOf<NativeHandler>(
        JobNativeHandler(job, JobNativeHandler.JobType.GENERATE_GEODATABASE)
    )
) {
    init {
        setMessageSink(messageSink)
    }
}