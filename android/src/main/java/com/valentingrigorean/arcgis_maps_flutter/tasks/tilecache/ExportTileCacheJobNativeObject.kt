package com.valentingrigorean.arcgis_maps_flutter.tasks.tilecache

import com.arcgismaps.tasks.tilecache.ExportTileCacheJob
import com.valentingrigorean.arcgis_maps_flutter.concurrent.JobNativeHandler
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeMessageSink

class ExportTileCacheJobNativeObject(
    objectId: String,
    job: ExportTileCacheJob,
    messageSink: NativeMessageSink
) : BaseNativeObject<ExportTileCacheJob>(
    objectId, job, arrayOf(
        JobNativeHandler(job),
    )
) {
    init {
        setMessageSink(messageSink)
    }
}