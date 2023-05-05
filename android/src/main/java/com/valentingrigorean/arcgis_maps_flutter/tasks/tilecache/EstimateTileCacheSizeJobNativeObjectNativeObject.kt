package com.valentingrigorean.arcgis_maps_flutter.tasks.tilecache

import com.arcgismaps.tasks.tilecache.EstimateTileCacheSizeJob
import com.valentingrigorean.arcgis_maps_flutter.concurrent.JobNativeHandler
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeMessageSink

class EstimateTileCacheSizeJobNativeObjectNativeObject(
    objectId: String,
    job: EstimateTileCacheSizeJob,
    messageSink: NativeMessageSink?
) : BaseNativeObject<EstimateTileCacheSizeJob>(
    objectId, job, arrayOf(
        JobNativeHandler(job),
    )
) {
    init {
        setMessageSink(messageSink)
    }
}