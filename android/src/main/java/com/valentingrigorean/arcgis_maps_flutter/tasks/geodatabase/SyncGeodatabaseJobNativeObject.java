package com.valentingrigorean.arcgis_maps_flutter.tasks.geodatabase;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.esri.arcgisruntime.tasks.geodatabase.GeodatabaseDeltaInfo;
import com.esri.arcgisruntime.tasks.geodatabase.SyncGeodatabaseJob;
import com.esri.arcgisruntime.tasks.geodatabase.SyncLayerResult;
import com.valentingrigorean.arcgis_maps_flutter.concurrent.JobNativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.io.RemoteResourceNativeHandler;

import java.util.List;

import io.flutter.plugin.common.MethodChannel;

public class SyncGeodatabaseJobNativeObject extends BaseNativeObject<SyncGeodatabaseJob> {
    public SyncGeodatabaseJobNativeObject(String objectId, SyncGeodatabaseJob job) {
        super(objectId, job, new NativeHandler[]{
                new JobNativeHandler(job, JobNativeHandler.JobType.SYNC_GEO_DATABASE),
                new RemoteResourceNativeHandler(job)
        });
    }

    @Override
    public void onMethodCall(@NonNull String method, @Nullable Object args, @NonNull MethodChannel.Result result) {
        switch (method) {
            case "syncGeodatabaseJob#getGeodatabaseDeltaInfo":
                final GeodatabaseDeltaInfo deltaInfo = getNativeObject().getGeodatabaseDeltaInfo();
                if(deltaInfo == null){
                    result.success(null);
                } else {
                    result.success(ConvertGeodatabase.geodatabaseDeltaInfoToJson(deltaInfo));
                }
                break;
            case "syncGeodatabaseJob#getResult":
                final List<SyncLayerResult> syncResults = getNativeObject().getResult();
                if(syncResults == null){
                    result.success(null);
                } else {
                    result.success(ConvertGeodatabase.syncLayerResultsToJson(syncResults));
                }
                break;
            default:
                super.onMethodCall(method, args, result);
                break;
        }
    }
}
