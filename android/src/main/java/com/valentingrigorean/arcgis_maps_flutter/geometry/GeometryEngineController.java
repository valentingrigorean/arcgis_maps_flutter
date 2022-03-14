package com.valentingrigorean.arcgis_maps_flutter.geometry;

import android.util.Log;

import androidx.annotation.NonNull;

import com.esri.arcgisruntime.geometry.AngularUnit;
import com.esri.arcgisruntime.geometry.AngularUnitId;
import com.esri.arcgisruntime.geometry.GeodeticCurveType;
import com.esri.arcgisruntime.geometry.GeodeticDistanceResult;
import com.esri.arcgisruntime.geometry.Geometry;
import com.esri.arcgisruntime.geometry.GeometryEngine;
import com.esri.arcgisruntime.geometry.LinearUnit;
import com.esri.arcgisruntime.geometry.LinearUnitId;
import com.esri.arcgisruntime.geometry.Point;
import com.esri.arcgisruntime.geometry.SpatialReference;
import com.valentingrigorean.arcgis_maps_flutter.Convert;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class GeometryEngineController implements MethodChannel.MethodCallHandler {
    private static final String TAG = "GeometryEngineController";
    private final MethodChannel channel;

    public GeometryEngineController(BinaryMessenger messenger) {
        channel = new MethodChannel(messenger, "plugins.flutter.io/geometry_engine");
        channel.setMethodCallHandler(this);
    }

    public void dispose() {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "project": {
                final Map<?, ?> data = Convert.toMap(call.arguments);
                final SpatialReference spatialReference = Convert.toSpatialReference(data.get("spatialReference"));
                final Geometry geometry = Convert.toGeometry(data.get("geometry"));
                final Geometry projectedGeometry = GeometryEngine.project(geometry, spatialReference);
                if (projectedGeometry == null) {
                    result.success(null);
                } else {
                    result.success(Convert.geometryToJson(projectedGeometry));
                }
            }
            break;
            case "distanceGeodetic": {
                final Map<?, ?> data = Convert.toMap(call.arguments);
                handleDistanceGeodetic(data, result);
            }
            break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void handleDistanceGeodetic(Map<?, ?> data, MethodChannel.Result result) {
        final Point point1 = (Point) Convert.toGeometry(data.get("point1"));
        final Point point2 = (Point) Convert.toGeometry(data.get("point2"));
        final LinearUnitId distanceUnitId = Convert.toLinearUnitId(data.get("distanceUnitId"));
        final AngularUnitId azimuthUnitId = Convert.toAngularUnitId(data.get("azimuthUnitId"));
        final GeodeticCurveType curveType = Convert.toGeodeticCurveType(data.get("curveType"));
        try {
            final GeodeticDistanceResult geodeticDistanceResult = GeometryEngine.distanceGeodetic(point1, point2, new LinearUnit(distanceUnitId), new AngularUnit(azimuthUnitId), curveType);
            if (geodeticDistanceResult == null) {
                result.success(null);
                return;
            }
            final Map<String, Object> json = new HashMap<>(4);
            json.put("distance", geodeticDistanceResult.getDistance());
            json.put("distanceUnitId", data.get("distanceUnitId"));
            json.put("azimuth1", geodeticDistanceResult.getAzimuth1());
            json.put("azimuth2", geodeticDistanceResult.getAzimuth2());
            json.put("angularUnitId", data.get("azimuthUnitId"));
            result.success(json);
        } catch (Exception ex) {
            Log.e(TAG, "Failed to get distanceGeodetic ", ex);
            result.success(null);
        }
    }

}
