package com.valentingrigorean.arcgis_maps_flutter.geometry;

import androidx.annotation.NonNull;

import com.esri.arcgisruntime.geometry.Geometry;
import com.esri.arcgisruntime.geometry.GeometryEngine;
import com.esri.arcgisruntime.geometry.SpatialReference;
import com.valentingrigorean.arcgis_maps_flutter.Convert;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class GeometryEngineController implements MethodChannel.MethodCallHandler {
    private final MethodChannel channel;

    public GeometryEngineController(BinaryMessenger messenger) {
        channel = new MethodChannel(messenger, "plugins.flutter.io/geometry_engine");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "project":
                final Map<?, ?> data = Convert.toMap(call.arguments);
                final SpatialReference spatialReference = Convert.toSpatialReference(data.get("spatialReference"));
                final Geometry geometry = Convert.toGeometry(data.get("geometry"));
                final Geometry projectedGeometry = GeometryEngine.project(geometry, spatialReference);
                if (projectedGeometry == null) {
                    result.success(null);
                } else {
                    final StringBuffer sb = new StringBuffer(projectedGeometry.toJson());
                    if(sb.length() > "{}".length()){
                        final String geometryType = ",\"geometryType\":" + projectedGeometry.getGeometryType().ordinal();
                        sb.insert(sb.length() - 1,geometryType);
                    }
                    result.success(sb.toString());
                }
                break;
            default:
                result.notImplemented();
                break;
        }
    }
}
