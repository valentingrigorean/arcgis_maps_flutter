package com.valentingrigorean.arcgis_maps_flutter.tasks.tilecache;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.esri.arcgisruntime.concurrent.ListenableFuture;
import com.esri.arcgisruntime.geometry.Geometry;
import com.esri.arcgisruntime.tasks.tilecache.EstimateTileCacheSizeJob;
import com.esri.arcgisruntime.tasks.tilecache.ExportTileCacheJob;
import com.esri.arcgisruntime.tasks.tilecache.ExportTileCacheParameters;
import com.esri.arcgisruntime.tasks.tilecache.ExportTileCacheTask;
import com.valentingrigorean.arcgis_maps_flutter.Convert;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.io.ApiKeyResourceNativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.io.RemoteResourceNativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.loadable.LoadableNativeHandler;

import java.util.Map;
import java.util.UUID;

import io.flutter.plugin.common.MethodChannel;

public class ExportTileCacheTaskNativeObject extends BaseNativeObject<ExportTileCacheTask> {

    public ExportTileCacheTaskNativeObject(String objectId, ExportTileCacheTask exportTileCacheTask) {
        super(objectId,exportTileCacheTask, new NativeHandler[]{
                new LoadableNativeHandler(exportTileCacheTask),
                new RemoteResourceNativeHandler(exportTileCacheTask),
                new ApiKeyResourceNativeHandler(exportTileCacheTask),
        });
    }

    @Override
    public void onMethodCall(@NonNull String method, @Nullable Object args, @NonNull MethodChannel.Result result) {
        switch (method) {
            case "exportTileCacheTask#createDefaultExportTileCacheParameters":
                createDefaultExportTileCacheParameters(args, result);
                break;
            case "exportTileCacheTask#estimateTileCacheSizeJob":
                estimateTileCacheSizeJob(args, result);
                break;
            case "exportTileCacheTask#exportTileCacheJob":
                exportTileCacheJob(args, result);
                break;
            default:
                super.onMethodCall(method, args, result);
                break;
        }
    }

    private void createDefaultExportTileCacheParameters(@Nullable Object args, @NonNull MethodChannel.Result result) {
        final Map<?, ?> data = Convert.toMap(args);
        final Geometry areaOfInterest = Convert.toGeometry(data.get("areaOfInterest"));
        final double minScale = Convert.toDouble(data.get("minScale"));
        final double maxScale = Convert.toDouble(data.get("maxScale"));
        ListenableFuture<ExportTileCacheParameters> future = getNativeObject().createDefaultExportTileCacheParametersAsync(areaOfInterest, minScale, maxScale);
        future.addDoneListener(() -> {
            try {
                result.success(ConvertTileCache.exportTileCacheParametersToJson(future.get()));
            } catch (Exception e) {
                result.error("createDefaultExportTileCacheParameters", e.getMessage(), null);
            }
        });
    }

    private void estimateTileCacheSizeJob(@Nullable Object args, @NonNull MethodChannel.Result result) {
        final ExportTileCacheParameters parameters = ConvertTileCache.toExportTileCacheParameters(args);
        final EstimateTileCacheSizeJob job = getNativeObject().estimateTileCacheSize(parameters);
        final String jobId = UUID.randomUUID().toString();
        final EstimateTileCacheSizeJobNativeObjectNativeObject jobNativeObject = new EstimateTileCacheSizeJobNativeObjectNativeObject(jobId, job, getMessageSink());
        getNativeObjectStorage().addNativeObject(jobNativeObject);
        result.success(jobId);
    }

    private void exportTileCacheJob(@Nullable Object args, @NonNull MethodChannel.Result result) {
        final Map<?, ?> data = Convert.toMap(args);
        final ExportTileCacheParameters parameters = ConvertTileCache.toExportTileCacheParameters(data.get("parameters"));
        final String fileNameWithPath = (String) data.get("fileNameWithPath");
        final ExportTileCacheJob job = getNativeObject().exportTileCache(parameters, fileNameWithPath);
        final String jobId = UUID.randomUUID().toString();
        final ExportTileCacheJobNativeObject jobNativeObject = new ExportTileCacheJobNativeObject(jobId, job, getMessageSink());
        getNativeObjectStorage().addNativeObject(jobNativeObject);
        result.success(jobId);
    }
}
