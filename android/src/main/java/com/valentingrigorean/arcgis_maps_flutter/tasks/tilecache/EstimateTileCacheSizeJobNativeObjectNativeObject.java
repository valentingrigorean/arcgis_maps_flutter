package com.valentingrigorean.arcgis_maps_flutter.tasks.tilecache;

import com.esri.arcgisruntime.tasks.tilecache.EstimateTileCacheSizeJob;
import com.valentingrigorean.arcgis_maps_flutter.concurrent.JobNativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.ArcgisNativeObjectController;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.ArcgisNativeObjectsController;

public class EstimateTileCacheSizeJobNativeObjectNativeObject extends ArcgisNativeObjectController {
    private final EstimateTileCacheSizeJob job;

    public EstimateTileCacheSizeJobNativeObjectNativeObject(String objectId, EstimateTileCacheSizeJob job, ArcgisNativeObjectsController.NativeObjectControllerMessageSink messageSink) {
        super(objectId, new NativeHandler[]{
                new JobNativeHandler(job, JobNativeHandler.JobType.ESTIMATE_TILE_CACHE_SIZE)
        }, messageSink);
        this.job = job;
    }

    public EstimateTileCacheSizeJob getJob() {
        return job;
    }
}
