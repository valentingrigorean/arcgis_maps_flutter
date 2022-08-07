package com.valentingrigorean.arcgis_maps_flutter.tasks.offlinemap;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.esri.arcgisruntime.concurrent.ListenableFuture;
import com.esri.arcgisruntime.geometry.Geometry;
import com.esri.arcgisruntime.tasks.offlinemap.GenerateOfflineMapJob;
import com.esri.arcgisruntime.tasks.offlinemap.GenerateOfflineMapParameters;
import com.esri.arcgisruntime.tasks.offlinemap.OfflineMapTask;
import com.valentingrigorean.arcgis_maps_flutter.Convert;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.loadable.LoadableNativeHandler;

import java.util.Map;
import java.util.UUID;

import io.flutter.plugin.common.MethodChannel;

public class OfflineMapTaskNativeObject extends BaseNativeObject<OfflineMapTask> {

    public OfflineMapTaskNativeObject(String objectId, OfflineMapTask task) {
        super(objectId, task, new NativeHandler[]{
                new LoadableNativeHandler(task),
        });
    }

    @Override
    public void onMethodCall(@NonNull String method, @Nullable Object args, @NonNull MethodChannel.Result result) {
        switch (method) {
            case "offlineMapTask#defaultGenerateOfflineMapParameters": {
                defaultGenerateOfflineMapParameters(Convert.toMap(args), result);
            }
            break;
            case "offlineMapTask#generateOfflineMap": {
                generateOfflineMap(Convert.toMap(args), result);
            }
            break;
            default:
                super.onMethodCall(method, args, result);
                break;
        }
    }

    private void defaultGenerateOfflineMapParameters(Map<?, ?> data, MethodChannel.Result result) {
        final Geometry areaOfInterest = Convert.toGeometry(data.get("areaOfInterest"));
        final Object minScale = data.get("minScale");
        final Object maxScale = data.get("maxScale");
        ListenableFuture<GenerateOfflineMapParameters> future;
        if (minScale == null) {
            future = getNativeObject().createDefaultGenerateOfflineMapParametersAsync(areaOfInterest);
        } else {
            future = getNativeObject().createDefaultGenerateOfflineMapParametersAsync(areaOfInterest, (double) minScale, (double) maxScale);
        }

        future.addDoneListener(() -> {
            try {
                final GenerateOfflineMapParameters parameters = future.get();
                result.success(ConvertOfflineMap.generateOfflineMapParametersToJson(parameters));
            } catch (Exception e) {
                result.error("defaultGenerateOfflineMapParameters", e.getMessage(), null);
            }
        });
    }

    private void generateOfflineMap(Map<?, ?> data, MethodChannel.Result result) {
        final GenerateOfflineMapParameters parameters = ConvertOfflineMap.toGenerateOfflineMapParameters(data.get("parameters"));
        final String downloadDirectory = (String) data.get("downloadDirectory");
        final GenerateOfflineMapJob offlineMapJob = getNativeObject().generateOfflineMap(parameters, downloadDirectory);
        final String jobId = UUID.randomUUID().toString();
        final GenerateOfflineMapJobNativeObject jobNativeObject = new GenerateOfflineMapJobNativeObject(jobId, offlineMapJob);
        jobNativeObject.setMessageSink(getMessageSink());
        getNativeObjectStorage().addNativeObject(jobNativeObject);
        result.success(jobId);
    }
}
