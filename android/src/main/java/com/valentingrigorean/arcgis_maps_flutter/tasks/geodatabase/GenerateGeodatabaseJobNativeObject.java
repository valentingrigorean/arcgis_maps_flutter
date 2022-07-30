package com.valentingrigorean.arcgis_maps_flutter.tasks.geodatabase;

import com.esri.arcgisruntime.tasks.geodatabase.GenerateGeodatabaseJob;
import com.valentingrigorean.arcgis_maps_flutter.concurrent.JobNativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.ArcgisNativeObjectsController;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler;

public class GenerateGeodatabaseJobNativeObject extends BaseNativeObject<GenerateGeodatabaseJob> {

    public GenerateGeodatabaseJobNativeObject(String objectId, GenerateGeodatabaseJob job, ArcgisNativeObjectsController.NativeObjectControllerMessageSink messageSink) {
        super(objectId, job, new NativeHandler[]{
                new JobNativeHandler(job, JobNativeHandler.JobType.GENERATE_GEODATABASE)
        });
        setMessageSink(messageSink);
    }
}
