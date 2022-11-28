package com.valentingrigorean.arcgis_maps_flutter.tasks.networkanalysis;

import static com.esri.arcgisruntime.loadable.LoadStatus.LOADED;

import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.esri.arcgisruntime.ArcGISRuntimeException;
import com.esri.arcgisruntime.concurrent.ListenableFuture;
import com.esri.arcgisruntime.loadable.LoadStatus;
import com.esri.arcgisruntime.tasks.networkanalysis.RouteParameters;
import com.esri.arcgisruntime.tasks.networkanalysis.RouteResult;
import com.esri.arcgisruntime.tasks.networkanalysis.RouteTask;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.io.ApiKeyResourceNativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.io.RemoteResourceNativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.loadable.LoadableNativeHandler;

import io.flutter.plugin.common.MethodChannel;

public class RouteTaskNativeObject extends BaseNativeObject<RouteTask> {
    static final String TAG = RouteTaskNativeObject.class.getSimpleName();

    public RouteTaskNativeObject(String objectId, RouteTask task) {
        super(objectId, task, new NativeHandler[]{new LoadableNativeHandler(task), new RemoteResourceNativeHandler(task), new ApiKeyResourceNativeHandler(task),});
    }

    @Override
    public void onMethodCall(@NonNull String method, @Nullable Object args, @NonNull MethodChannel.Result result) {
        switch (method) {
            case "routeTask#getRouteTaskInfo":
                getRouteTaskInfo(result);
                break;
            case "routeTask#createDefaultParameters":
                createDefaultParameters(result);
                break;
            case "routeTask#solveRoute":
                solveRoute(args, result);
                break;
            default:
                super.onMethodCall(method, args, result);
        }
    }


    private void getRouteTaskInfo(MethodChannel.Result result) {
        final RouteTask routeTask = getNativeObject();
        routeTask.loadAsync();
        routeTask.addDoneLoadingListener(() -> {
            if (routeTask.getLoadStatus() == LOADED) {
                result.success(ConvertRouteTask.routeTaskInfoToJson(routeTask.getRouteTaskInfo()));
            } else if (routeTask.getLoadStatus() == LoadStatus.FAILED_TO_LOAD) {
                final ArcGISRuntimeException exception = routeTask.getLoadError();
                result.error("ERROR", exception != null ? exception.getMessage() : "Unknown error.", null);
            }
        });
    }

    private void createDefaultParameters(MethodChannel.Result result) {
        final ListenableFuture<RouteParameters> future = getNativeObject().createDefaultParametersAsync();
        future.addDoneListener(() -> {
            try {
                final RouteParameters routeParameters = future.get();
                result.success(ConvertRouteTask.routeParametersToJson(routeParameters));
            } catch (Exception e) {
                Log.e(TAG, "Failed to create default parameters.", e);
                result.error("ERROR", "Failed to create default parameters.", e.getMessage());
            }
        });
    }

    private void solveRoute(Object args, MethodChannel.Result result) {
        final RouteParameters routeParameters = ConvertRouteTask.toRouteParameters(args);
        final ListenableFuture<RouteResult> future = getNativeObject().solveRouteAsync(routeParameters);
        future.addDoneListener(() -> {
            try {
                final RouteResult routeResult = future.get();
                result.success(ConvertRouteTask.routeResultToJson(routeResult));
            } catch (Exception e) {
                Log.e(TAG, "Failed to solve route.", e);
                result.error("ERROR", "Failed to solve route.", e.getMessage());
            }
        });
    }

}
