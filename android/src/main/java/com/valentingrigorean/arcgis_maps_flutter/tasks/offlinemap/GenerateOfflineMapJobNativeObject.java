package com.valentingrigorean.arcgis_maps_flutter.tasks.offlinemap;

import com.esri.arcgisruntime.tasks.offlinemap.GenerateOfflineMapJob;
import com.valentingrigorean.arcgis_maps_flutter.concurrent.JobNativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.io.RemoteResourceNativeHandler;

public class GenerateOfflineMapJobNativeObject extends BaseNativeObject<GenerateOfflineMapJob> {

    public GenerateOfflineMapJobNativeObject(String jobId, GenerateOfflineMapJob job) {
        super(jobId, job, new NativeHandler[]{
                new JobNativeHandler(job, JobNativeHandler.JobType.GENERATE_OFFLINE_MAP),
                new RemoteResourceNativeHandler(job),
        });
    }

}
