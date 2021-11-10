package com.valentingrigorean.arcgis_maps_flutter.tasks.geocode;

import android.util.Log;

import androidx.annotation.NonNull;

import com.esri.arcgisruntime.ArcGISRuntimeException;
import com.esri.arcgisruntime.concurrent.ListenableFuture;
import com.esri.arcgisruntime.loadable.LoadStatus;
import com.esri.arcgisruntime.tasks.geocode.GeocodeResult;
import com.esri.arcgisruntime.tasks.geocode.LocatorTask;
import com.valentingrigorean.arcgis_maps_flutter.Convert;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class LocatorTaskController implements MethodChannel.MethodCallHandler {

    private static final String TAG = "LocatorTaskController";

    private final Map<Integer, LocatorTask> locatorTasks = new HashMap<>();

    private final MethodChannel channel;

    public LocatorTaskController(BinaryMessenger messenger) {
        channel = new MethodChannel(messenger, "plugins.flutter.io/locator_task");
        channel.setMethodCallHandler(this);
    }

    public void dispose() {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "createLocatorTask":
                createLocatorTask(Convert.toMap(call.arguments));
                result.success(null);
                break;
            case "destroyLocatorTask":
                locatorTasks.remove(call.arguments());
                result.success(null);
                break;
            case "getLocatorInfo":
                getLocatorInfo(call.arguments(), result);
                break;
            case "reverseGeocode":
                reverseGeocode(call.arguments(), result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void getLocatorInfo(int id, MethodChannel.Result result) {
        final LocatorTask locatorTask = locatorTasks.get(id);
        if (locatorTask == null) {
            result.error("ERROR", "No LocatorTask found with id:" + id, null);
            return;
        }
        if (locatorTask.getLoadStatus() != LoadStatus.LOADED) {
            locatorTask.loadAsync();
        }
        locatorTask.addDoneLoadingListener(() -> {
            if (locatorTask.getLoadStatus() == LoadStatus.LOADED) {
                result.success(Convert.locatorInfoToJson(locatorTask.getLocatorInfo()));
            } else {
                final ArcGISRuntimeException exception = locatorTask.getLoadError();
                result.error("ERROR", exception != null ? exception.getMessage() : "Unknown error.", null);
            }
        });
    }

    private void reverseGeocode(Map<?, ?> data, MethodChannel.Result result) {
        final LocatorTask locatorTask = locatorTasks.get(data.get("id"));
        ListenableFuture<List<GeocodeResult>> future = locatorTask.reverseGeocodeAsync(Convert.toPoint(data.get("location")));
        future.addDoneListener(() -> {
            try {
                List<GeocodeResult> results = future.get();
                result.success(Convert.geocodeResultsToJson(results));
            } catch (Exception e) {
                Log.e(TAG, "reverseGeocode: Failed to reverse geocode", e);
                result.error("ERROR", "Failed to reverse geocode.", e.getMessage());
            }
        });
    }


    private void createLocatorTask(Map<?, ?> data) {
        final String url = (String) data.get("url");
        final LocatorTask locatorTask = new LocatorTask(url);

        final Object credential = data.get("credential");
        if (credential != null) {
            locatorTask.setCredential(Convert.toCredentials(credential));
        }
        locatorTasks.put(Convert.toInt(data.get("id")), locatorTask);
    }
}
