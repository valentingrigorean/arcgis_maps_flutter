package com.valentingrigorean.arcgis_maps_flutter.tasks.networkanalysis;


import static com.esri.arcgisruntime.loadable.LoadStatus.LOADED;

import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import com.esri.arcgisruntime.ArcGISRuntimeException;
import com.esri.arcgisruntime.concurrent.ListenableFuture;
import com.esri.arcgisruntime.loadable.LoadStatus;
import com.esri.arcgisruntime.tasks.networkanalysis.RouteParameters;
import com.esri.arcgisruntime.tasks.networkanalysis.RouteResult;
import com.esri.arcgisruntime.tasks.networkanalysis.RouteTask;
import com.valentingrigorean.arcgis_maps_flutter.Convert;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class RouteTaskController implements MethodChannel.MethodCallHandler {

    private static String TAG = "RouteTaskController";

    private final Map<Integer, RouteTask> routeTasks = new HashMap<>();
    private final Context context;
    private final MethodChannel channel;

    public RouteTaskController(Context context, BinaryMessenger messenger) {
        this.context = context;
        channel = new MethodChannel(messenger, "plugins.flutter.io/route_task");
        channel.setMethodCallHandler(this);
    }

    public void dispose() {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {

        switch (call.method) {
            case "createRouteTask":
                createRouteTask(call.arguments());
                result.success(null);
                break;
            case "destroyRouteTask":
                routeTasks.remove(call.arguments());
                result.success(null);
                break;
            case "getRouteTaskInfo":
                getRouteTaskInfo(call.arguments(), result);
                break;
            case "createDefaultParameters":
                createDefaultParameters(call.arguments(), result);
                break;
            case "solveRoute":
                solveRoute(call.arguments(), result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void createRouteTask(Map<?, ?> data) {
        RouteTask routeTask = new RouteTask(context, data.get("url").toString());
        final Object credentials = data.get("credentials");
        if (credentials != null) {
            routeTask.setCredential(Convert.toCredentials(credentials));
        }
        routeTasks.put(Convert.toInt(data.get("id")), routeTask);
    }

    private void getRouteTaskInfo(int id, MethodChannel.Result result) {
        RouteTask routeTask = routeTasks.get(id);
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

    private void createDefaultParameters(int id, MethodChannel.Result result) {
        RouteTask routeTask = routeTasks.get(id);
        final ListenableFuture<RouteParameters> future = routeTask.createDefaultParametersAsync();
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


    private void solveRoute(Map<?, ?> data, MethodChannel.Result result) {
        RouteTask routeTask = routeTasks.get(Convert.toInt(data.get("id")));
        final Object parameters = data.get("parameters");
        final RouteParameters routeParameters = ConvertRouteTask.toRouteParameters(parameters);
        final ListenableFuture<RouteResult> future = routeTask.solveRouteAsync(routeParameters);
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
