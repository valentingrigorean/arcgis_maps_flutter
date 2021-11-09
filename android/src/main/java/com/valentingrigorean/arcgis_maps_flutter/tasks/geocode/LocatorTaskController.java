package com.valentingrigorean.arcgis_maps_flutter.tasks.geocode;

import android.util.Log;

import androidx.annotation.NonNull;

import com.esri.arcgisruntime.concurrent.ListenableFuture;
import com.esri.arcgisruntime.tasks.geocode.GeocodeResult;
import com.esri.arcgisruntime.tasks.geocode.LocatorTask;
import com.valentingrigorean.arcgis_maps_flutter.Convert;

import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class LocatorTaskController implements MethodChannel.MethodCallHandler {

    private static final String TAG = "LocatorTaskController";

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
            case "reverseGeocode":
                reverseGeocode(Convert.toMap(call.arguments), result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void reverseGeocode(Map<?, ?> data, MethodChannel.Result result) {
        final LocatorTask locatorTask = createLocatorTask(data);
        ListenableFuture<List<GeocodeResult>> future = locatorTask.reverseGeocodeAsync(Convert.toPoint(data.get("location")));
        future.addDoneListener(() -> {
            try {
                List<GeocodeResult> results = future.get();
                result.success(Convert.geocodeResultsToJson(results));
            } catch (Exception e) {
                Log.e(TAG, "reverseGeocode: Failed to reverse geocode", e);
                result.error("Failed to reverse geocode.", e.getMessage(), null);
            }
        });
    }

    private static LocatorTask createLocatorTask(Map<?, ?> data) {
        final String url = (String) data.get("url");
        final LocatorTask locatorTask = new LocatorTask(url);

        final Object credential = data.get("credential");
        if (credential != null) {
            locatorTask.setCredential(Convert.toCredentials(credential));
        }

        return locatorTask;
    }
}
