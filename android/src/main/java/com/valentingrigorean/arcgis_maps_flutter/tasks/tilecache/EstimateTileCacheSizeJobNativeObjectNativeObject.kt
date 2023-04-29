package com.valentingrigorean.arcgis_maps_flutter.tasks.tilecache

import com.esri.arcgisruntime.tasks.tilecache.EstimateTileCacheSizeJob
import com.valentingrigorean.arcgis_maps_flutter.concurrent.JobNativeHandler
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeMessageSink
import com.valentingrigorean.arcgis_maps_flutter.io.RemoteResourceNativeHandler

class EstimateTileCacheSizeJobNativeObjectNativeObject(
    objectId: String?,
    job: EstimateTileCacheSizeJob,
    messageSink: NativeMessageSink?
) : BaseNativeObject<EstimateTileCacheSizeJob?>(
    objectId, job, arrayOf<NativeHandler>(
        JobNativeHandler(job, JobNativeHandler.JobType.ESTIMATE_TILE_CACHE_SIZE),
        RemoteResourceNativeHandler(job)
    )
) {
    init {
        setMessageSink(messageSink)
    }
}