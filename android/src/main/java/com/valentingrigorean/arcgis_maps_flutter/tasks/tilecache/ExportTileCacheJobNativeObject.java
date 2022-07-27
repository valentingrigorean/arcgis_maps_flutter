package com.valentingrigorean.arcgis_maps_flutter.tasks.tilecache;

import com.esri.arcgisruntime.tasks.tilecache.ExportTileCacheJob;
import com.valentingrigorean.arcgis_maps_flutter.concurrent.JobNativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.ArcgisNativeObjectController;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.ArcgisNativeObjectsController;

public class ExportTileCacheJobNativeObject extends ArcgisNativeObjectController {
    private final ExportTileCacheJob job;

    public ExportTileCacheJobNativeObject(String objectId, ExportTileCacheJob job, ArcgisNativeObjectsController.NativeObjectControllerMessageSink messageSink) {
        super(objectId, new NativeHandler[]{
                new JobNativeHandler(job, JobNativeHandler.JobType.EXPORT_TILE_CACHE)
        }, messageSink);
        this.job = job;
    }

    public ExportTileCacheJob getJob() {
        return job;
    }
}
