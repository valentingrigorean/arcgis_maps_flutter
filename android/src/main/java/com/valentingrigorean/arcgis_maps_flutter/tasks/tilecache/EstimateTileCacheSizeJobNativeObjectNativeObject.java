package com.valentingrigorean.arcgis_maps_flutter.tasks.tilecache;

import com.esri.arcgisruntime.tasks.tilecache.EstimateTileCacheSizeJob;
import com.valentingrigorean.arcgis_maps_flutter.concurrent.JobNativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.ArcgisNativeObjectsController;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler;

public class EstimateTileCacheSizeJobNativeObjectNativeObject extends BaseNativeObject<EstimateTileCacheSizeJob> {

    public EstimateTileCacheSizeJobNativeObjectNativeObject(String objectId, EstimateTileCacheSizeJob job, ArcgisNativeObjectsController.NativeObjectControllerMessageSink messageSink) {
        super(objectId, job, new NativeHandler[]{
                new JobNativeHandler(job, JobNativeHandler.JobType.ESTIMATE_TILE_CACHE_SIZE)
        });
        setMessageSink(messageSink);
    }
}
