package com.valentingrigorean.arcgis_maps_flutter.tasks.geocode;

import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.esri.arcgisruntime.ArcGISRuntimeException;
import com.esri.arcgisruntime.concurrent.ListenableFuture;
import com.esri.arcgisruntime.geometry.Point;
import com.esri.arcgisruntime.loadable.LoadStatus;
import com.esri.arcgisruntime.tasks.geocode.GeocodeResult;
import com.esri.arcgisruntime.tasks.geocode.LocatorTask;
import com.esri.arcgisruntime.tasks.geocode.SuggestResult;
import com.valentingrigorean.arcgis_maps_flutter.Convert;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.io.ApiKeyResourceNativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.io.RemoteResourceNativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.loadable.LoadableNativeHandler;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import io.flutter.plugin.common.MethodChannel;

public class LocatorTaskNativeObject extends BaseNativeObject<LocatorTask> {

    private final Map<String, SuggestResult> suggestResultsMap = new HashMap<>();
    static final String TAG = LocatorTaskNativeObject.class.getSimpleName();

    public LocatorTaskNativeObject(String objectId, LocatorTask task) {
        super(objectId, task, new NativeHandler[]{new LoadableNativeHandler(task), new RemoteResourceNativeHandler(task), new ApiKeyResourceNativeHandler(task),});
    }

    @Override
    protected void disposeInternal() {
        super.disposeInternal();
        suggestResultsMap.clear();
    }

    @Override
    public void onMethodCall(@NonNull String method, @Nullable Object args, @NonNull MethodChannel.Result result) {
        switch (method) {
            case "locatorTask#getLocatorInfo":
                getLocatorInfo(result);
                break;
            case "locatorTask#geocode":
                geocode(args, result);
                break;
            case "locatorTask#geocodeSuggestResult":
                geocodeSuggestResult(args, result);
                break;
            case "locatorTask#geocodeSearchValues":
                geocodeSearchValues(args, result);
                break;
            case "locatorTask#reverseGeocode":
                reverseGeocode(args, result);
                break;
            case "locatorTask#suggest":
                suggest(args, result);
                break;
            case "locatorTask#releaseSuggestResults":
                releaseSuggestResults(args);
                result.success(null);
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

    private void geocode(Object args, MethodChannel.Result result) {
        final Map<?, ?> data = Convert.toMap(args);
        final String searchText = data.get("searchText").toString();
        final Object parameters = data.get("parameters");
        ListenableFuture<List<GeocodeResult>> future;
        if (parameters == null) {
            future = getNativeObject().geocodeAsync(searchText);
        } else {
            future = getNativeObject().geocodeAsync(searchText, ConvertLocatorTask.toGeocodeParameters(parameters));
        }
        future.addDoneListener(() -> {
            try {
                final List<GeocodeResult> geocodeResults = future.get();
                result.success(ConvertLocatorTask.geocodeResultsToJson(geocodeResults));
            } catch (Exception e) {
                Log.e(TAG, "geocode: ", e);
                result.error("ERROR", e.getMessage(), null);
            }
        });
    }

    private void geocodeSuggestResult(Object args, MethodChannel.Result result) {
        final Map<?, ?> data = Convert.toMap(args);
        final String tag = data.get("suggestResultId").toString();
        final SuggestResult suggestResult = suggestResultsMap.get(tag);
        if (suggestResult == null) {
            result.error("ERROR", "SuggestResult not found", null);
            return;
        }
        final Object parameters = data.get("parameters");
        ListenableFuture<List<GeocodeResult>> future;
        if (parameters == null) {
            future = getNativeObject().geocodeAsync(suggestResult);
        } else {
            future = getNativeObject().geocodeAsync(suggestResult, ConvertLocatorTask.toGeocodeParameters(parameters));
        }
        future.addDoneListener(() -> {
            try {
                final List<GeocodeResult> geocodeResults = future.get();
                result.success(ConvertLocatorTask.geocodeResultsToJson(geocodeResults));
            } catch (Exception e) {
                Log.e(TAG, "geocode: ", e);
                result.error("ERROR", e.getMessage(), null);
            }
        });
    }

    private void geocodeSearchValues(Object args, MethodChannel.Result result) {
        final Map<?, ?> data = Convert.toMap(args);
        final Map<String,String> searchValues = ((Map<String,String>) Convert.toMap(data.get("searchValues")));
        final Object parameters = data.get("parameters");
        ListenableFuture<List<GeocodeResult>> future;
        if (parameters == null) {
            future = getNativeObject().geocodeAsync(searchValues);
        } else {
            future = getNativeObject().geocodeAsync(searchValues, ConvertLocatorTask.toGeocodeParameters(parameters));
        }
        future.addDoneListener(() -> {
            try {
                final List<GeocodeResult> geocodeResults = future.get();
                result.success(ConvertLocatorTask.geocodeResultsToJson(geocodeResults));
            } catch (Exception e) {
                Log.e(TAG, "geocode: ", e);
                result.error("ERROR", e.getMessage(), null);
            }
        });
    }

    private void reverseGeocode(Object args, MethodChannel.Result result) {
        final LocatorTask locatorTask = getNativeObject();
        final Map<?, ?> data = Convert.toMap(args);
        final Point location = Convert.toPoint(data.get("location"));
        final Object parameters = data.get("parameters");
        ListenableFuture<List<GeocodeResult>> future;
        if (parameters == null) {
            future = locatorTask.reverseGeocodeAsync(location);
        } else {
            future = locatorTask.reverseGeocodeAsync(location, ConvertLocatorTask.toReverseGeocodeParameters(parameters));
        }
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

    private void suggest(Object args, MethodChannel.Result result) {
        final LocatorTask locatorTask = getNativeObject();
        final Map<?, ?> data = Convert.toMap(args);
        final String searchText = data.get("searchText").toString();
        final Object parameters = data.get("parameters");
        ListenableFuture<List<SuggestResult>> future;
        if (parameters == null) {
            future = locatorTask.suggestAsync(searchText);
        } else {
            future = locatorTask.suggestAsync(searchText, ConvertLocatorTask.toSuggestParameters(parameters));
        }

        future.addDoneListener(() -> {
            try {
                List<SuggestResult> results = future.get();
                result.success(ConvertLocatorTask.suggestResultsToJson(results, suggestResult -> {
                    final String tag = UUID.randomUUID().toString();
                    suggestResultsMap.put(tag, suggestResult);
                    return tag;
                }));
            } catch (Exception e) {
                Log.e(TAG, "suggest: Failed to suggest", e);
                result.error("ERROR", "Failed to suggest.", e.getMessage());
            }
        });
    }

    private void releaseSuggestResults(Object args) {
        if(args == null){
            suggestResultsMap.clear();
            return;
        }
        final List<?> tags = Convert.toList(args);
        for (Object tag : tags) {
            suggestResultsMap.remove(tag.toString());
        }
    }
}
