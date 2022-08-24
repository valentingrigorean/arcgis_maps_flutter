package com.valentingrigorean.arcgis_maps_flutter.tasks.offlinemap;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.esri.arcgisruntime.tasks.geodatabase.GeodatabaseDeltaInfo;
import com.esri.arcgisruntime.tasks.offlinemap.OfflineMapSyncJob;
import com.esri.arcgisruntime.tasks.offlinemap.OfflineMapSyncResult;
import com.esri.arcgisruntime.util.ListenableList;
import com.valentingrigorean.arcgis_maps_flutter.concurrent.JobNativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.io.RemoteResourceNativeHandler;

import java.util.ArrayList;

import io.flutter.plugin.common.MethodChannel;

public class OfflineMapSyncJobNativeObject extends BaseNativeObject<OfflineMapSyncJob> {
    public OfflineMapSyncJobNativeObject(String objectId, OfflineMapSyncJob job) {
        super(objectId, job, new NativeHandler[]{
                new JobNativeHandler(job, JobNativeHandler.JobType.OFFLINE_MAP_SYNC),
                new RemoteResourceNativeHandler(job),
        });
    }

    @Override
    public void onMethodCall(@NonNull String method, @Nullable Object args, @NonNull MethodChannel.Result result) {
        switch (method) {
            case "offlineMapSyncJob#getGeodatabaseDeltaInfos": {
                final ListenableList<GeodatabaseDeltaInfo> geodatabaseDeltaInfos = getNativeObject().getGeodatabaseDeltaInfos();
                final ArrayList<Object> list = new ArrayList<>(geodatabaseDeltaInfos.size());
                for (GeodatabaseDeltaInfo geodatabaseDeltaInfo : geodatabaseDeltaInfos) {
                    list.add(ConvertOfflineMap.geodatabaseDeltaInfoToJson(geodatabaseDeltaInfo));
                }
                result.success(list);
            }
            break;
            case "offlineMapSyncJob#getResult": {
                final OfflineMapSyncResult syncResult = getNativeObject().getResult();
                if (syncResult != null) {
                    result.success(ConvertOfflineMap.offlineMapSyncResultToJson(syncResult));
                } else {
                    result.success(null);
                }
            }
            break;
            default:
                super.onMethodCall(method, args, result);
                break;
        }
    }
}
