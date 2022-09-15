package com.valentingrigorean.arcgis_maps_flutter.tasks.tilecache;

import com.esri.arcgisruntime.tasks.tilecache.EstimateTileCacheSizeJob;
import com.valentingrigorean.arcgis_maps_flutter.concurrent.JobNativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.ArcgisNativeObjectsController;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeMessageSink;
import com.valentingrigorean.arcgis_maps_flutter.io.RemoteResourceNativeHandler;

public class EstimateTileCacheSizeJobNativeObjectNativeObject extends BaseNativeObject<EstimateTileCacheSizeJob> {

    public EstimateTileCacheSizeJobNativeObjectNativeObject(String objectId, EstimateTileCacheSizeJob job, NativeMessageSink messageSink) {
        super(objectId, job, new NativeHandler[]{
                new JobNativeHandler(job, JobNativeHandler.JobType.ESTIMATE_TILE_CACHE_SIZE),
                new RemoteResourceNativeHandler(job),
        });
        setMessageSink(messageSink);
    }
}
