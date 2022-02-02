package com.valentingrigorean.arcgis_maps_flutter.tasks.networkanalysis;


import androidx.annotation.NonNull;

import com.esri.arcgisruntime.tasks.networkanalysis.RouteTask;
import com.esri.arcgisruntime.tasks.networkanalysis.Stop;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class RouteTaskController implements MethodChannel.MethodCallHandler {
    private final Map<Integer, RouteTask> locatorTasks = new HashMap<>();

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {

        Stop stop;
        stop.getNetworkLocation();
        switch (call.method) {

            default:
                result.notImplemented();
                break;
        }
    }
}
