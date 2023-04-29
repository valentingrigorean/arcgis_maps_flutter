package com.valentingrigorean.arcgis_maps_flutter.tasks.tilecache

import com.esri.arcgisruntime.tasks.tilecache.ExportTileCacheJob
import com.valentingrigorean.arcgis_maps_flutter.concurrent.JobNativeHandler
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeMessageSink
import com.valentingrigorean.arcgis_maps_flutter.io.RemoteResourceNativeHandler

class ExportTileCacheJobNativeObject(
    objectId: String?,
    job: ExportTileCacheJob,
    messageSink: NativeMessageSink?
) : BaseNativeObject<ExportTileCacheJob?>(
    objectId, job, arrayOf<NativeHandler>(
        JobNativeHandler(job, JobNativeHandler.JobType.EXPORT_TILE_CACHE),
        RemoteResourceNativeHandler(job)
    )
) {
    init {
        setMessageSink(messageSink)
    }
}