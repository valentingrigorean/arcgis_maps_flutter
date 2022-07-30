package com.valentingrigorean.arcgis_maps_flutter.tasks.geodatabase;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.esri.arcgisruntime.concurrent.ListenableFuture;
import com.esri.arcgisruntime.geometry.Geometry;
import com.esri.arcgisruntime.tasks.geodatabase.GenerateGeodatabaseJob;
import com.esri.arcgisruntime.tasks.geodatabase.GenerateGeodatabaseParameters;
import com.esri.arcgisruntime.tasks.geodatabase.GeodatabaseSyncTask;
import com.valentingrigorean.arcgis_maps_flutter.Convert;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.io.ApiKeyResourceNativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.io.RemoteResourceNativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.loadable.LoadableNativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.tasks.tilecache.ExportTileCacheJobNativeObject;

import java.util.Map;
import java.util.UUID;

import io.flutter.plugin.common.MethodChannel;

public class GeodatabaseSyncTaskNativeObject extends BaseNativeObject<GeodatabaseSyncTask> {
    public GeodatabaseSyncTaskNativeObject(String objectId, GeodatabaseSyncTask task) {
        super(objectId, task, new NativeHandler[]{
                new LoadableNativeHandler(task),
                new RemoteResourceNativeHandler(task),
                new ApiKeyResourceNativeHandler(task),
        });
    }

    @Override
    public void onMethodCall(@NonNull String method, @Nullable Object args, @NonNull MethodChannel.Result result) {
        switch (method) {
            case "geodatabaseSyncTask#defaultGenerateGeodatabaseParameters":
                defaultGenerateGeodatabaseParameters(args, result);
                break;
            case "geodatabaseSyncTask#generateJob":
                generateJob(args, result);
                break;
            default:
                super.onMethodCall(method, args, result);
        }
    }

    private void defaultGenerateGeodatabaseParameters(Object args, MethodChannel.Result result) {
        final Geometry areaOfInterest = Convert.toGeometry(args);
        final ListenableFuture<GenerateGeodatabaseParameters> future = getNativeObject().createDefaultGenerateGeodatabaseParametersAsync(areaOfInterest);
        future.addDoneListener(() -> {
            try {
                result.success(ConvertGeodatabase.generateGeodatabaseParametersToJson(future.get()));
            } catch (Exception e) {
                result.error("defaultGenerateGeodatabaseParameters", e.getMessage(), null);
            }
        });
    }

    private void generateJob(Object args, MethodChannel.Result result) {
        final Map<?, ?> data = Convert.toMap(args);
        final GenerateGeodatabaseParameters parameters = ConvertGeodatabase.toGenerateGeodatabaseParameters(data.get("parameters"));
        final String fileNameWithPath = (String) data.get("fileNameWithPath");
        final GenerateGeodatabaseJob job = getNativeObject().generateGeodatabase(parameters, fileNameWithPath);
        final String jobId  = UUID.randomUUID().toString();
        final GenerateGeodatabaseJobNativeObject jobNativeObject = new GenerateGeodatabaseJobNativeObject(jobId, job, getMessageSink());
        getNativeObjectStorage().addNativeObject(jobNativeObject);
        result.success(jobId);
    }
}
