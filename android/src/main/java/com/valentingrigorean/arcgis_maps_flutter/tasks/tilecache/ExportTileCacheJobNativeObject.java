package com.valentingrigorean.arcgis_maps_flutter.tasks.tilecache;

import com.esri.arcgisruntime.tasks.tilecache.ExportTileCacheJob;
import com.valentingrigorean.arcgis_maps_flutter.concurrent.JobNativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.ArcgisNativeObjectsController;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.io.RemoteResourceNativeHandler;

public class ExportTileCacheJobNativeObject extends BaseNativeObject<ExportTileCacheJob> {

    public ExportTileCacheJobNativeObject(String objectId, ExportTileCacheJob job, ArcgisNativeObjectsController.NativeObjectControllerMessageSink messageSink) {
        super(objectId, job, new NativeHandler[]{
                new JobNativeHandler(job, JobNativeHandler.JobType.EXPORT_TILE_CACHE),
                new RemoteResourceNativeHandler(job),
        });
        setMessageSink(messageSink);
    }
}
