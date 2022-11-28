package com.valentingrigorean.arcgis_maps_flutter.tasks.geocode;

import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.esri.arcgisruntime.ArcGISRuntimeException;
import com.esri.arcgisruntime.concurrent.ListenableFuture;
import com.esri.arcgisruntime.loadable.LoadStatus;
import com.esri.arcgisruntime.tasks.geocode.GeocodeResult;
import com.esri.arcgisruntime.tasks.geocode.LocatorTask;
import com.valentingrigorean.arcgis_maps_flutter.Convert;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.io.ApiKeyResourceNativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.io.RemoteResourceNativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.loadable.LoadableNativeHandler;

import java.util.List;

import io.flutter.plugin.common.MethodChannel;

public class LocatorTaskNativeObject extends BaseNativeObject<LocatorTask> {

    static final String TAG = LocatorTaskNativeObject.class.getSimpleName();

    public LocatorTaskNativeObject(String objectId, LocatorTask task) {
        super(objectId, task, new NativeHandler[]{new LoadableNativeHandler(task), new RemoteResourceNativeHandler(task), new ApiKeyResourceNativeHandler(task),});
    }

    @Override
    public void onMethodCall(@NonNull String method, @Nullable Object args, @NonNull MethodChannel.Result result) {
        switch (method) {
            case "locatorTask#getLocatorInfo":
                getLocatorInfo(result);
                break;
            case "locatorTask#reverseGeocode":
                reverseGeocode(args, result);
                break;
            default:
                super.onMethodCall(method, args, result);
        }
    }

    private void getLocatorInfo(MethodChannel.Result result) {
        final LocatorTask locatorTask = getNativeObject();
        if (locatorTask.getLoadStatus() != LoadStatus.LOADED) {
            locatorTask.loadAsync();
        }
        locatorTask.addDoneLoadingListener(() -> {
            if (locatorTask.getLoadStatus() == LoadStatus.LOADED) {
                result.success(ConvertLocatorTask.locatorInfoToJson(locatorTask.getLocatorInfo()));
            } else {
                final ArcGISRuntimeException exception = locatorTask.getLoadError();
                result.error("ERROR", exception != null ? exception.getMessage() : "Unknown error.", null);
            }
        });
    }


    private void reverseGeocode(Object args, MethodChannel.Result result) {
        final LocatorTask locatorTask = getNativeObject();
        ListenableFuture<List<GeocodeResult>> future = locatorTask.reverseGeocodeAsync(Convert.toPoint(args));
        future.addDoneListener(() -> {
            try {
                List<GeocodeResult> results = future.get();
                result.success(ConvertLocatorTask.geocodeResultsToJson(results));
            } catch (Exception e) {
                Log.e(TAG, "reverseGeocode: Failed to reverse geocode", e);
                result.error("ERROR", "Failed to reverse geocode.", e.getMessage());
            }
        });
    }
}
