package com.valentingrigorean.arcgis_maps_flutter.geometry;

import android.util.Log;

import androidx.annotation.NonNull;

import com.esri.arcgisruntime.geometry.AngularUnit;
import com.esri.arcgisruntime.geometry.AngularUnitId;
import com.esri.arcgisruntime.geometry.GeodesicSectorParameters;
import com.esri.arcgisruntime.geometry.GeodeticCurveType;
import com.esri.arcgisruntime.geometry.GeodeticDistanceResult;
import com.esri.arcgisruntime.geometry.Geometry;
import com.esri.arcgisruntime.geometry.GeometryEngine;
import com.esri.arcgisruntime.geometry.LinearUnit;
import com.esri.arcgisruntime.geometry.LinearUnitId;
import com.esri.arcgisruntime.geometry.Point;
import com.esri.arcgisruntime.geometry.Polygon;
import com.esri.arcgisruntime.geometry.SpatialReference;
import com.valentingrigorean.arcgis_maps_flutter.Convert;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class GeometryEngineController implements MethodChannel.MethodCallHandler {
    private static final String TAG = "GeometryEngineController";
    private final MethodChannel channel;

    public GeometryEngineController(BinaryMessenger messenger) {
        channel = new MethodChannel(messenger, "plugins.flutter.io/arcgis_channel/geometry_engine");
        channel.setMethodCallHandler(this);
    }

    public void dispose() {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "project": {
                handleProject(call.arguments(), result);
            }
            break;
            case "distanceGeodetic": {
                final Map<?, ?> data = Convert.toMap(call.arguments);
                handleDistanceGeodetic(data, result);
            }
            break;
            case "bufferGeometry": {
                handleBufferGeometry(call.arguments(), result);
            }
            break;
            case "geodeticBufferGeometry": {
                handleGeodeticBufferGeometry(call.arguments(), result);
            }
            break;
            case "intersection": {
                handleIntersection(call.arguments(), result);
            }
            break;
            case "intersections": {
                handleIntersections(call.arguments(), result);
            }
            break;
            case "geodesicSector": {
                final GeodesicSectorParameters params = Convert.toGeodesicSectorParameters(call.arguments);
                final Geometry geometry = GeometryEngine.sectorGeodesic(params);
                result.success(Convert.geometryToJson(geometry));
            }
            break;
            case "geodeticMove": {
                handleGeodeticMove(call.arguments(), result);
            }
            case "simplify": {
                handleSimply(call.arguments(), result);
            }
            case "isSimple": {
                handleIsSimple(call.arguments(), result);
            }
            break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void handleGeodeticMove(Map<?, ?> data, MethodChannel.Result result) {
        final List<?> rawPoints = Convert.toList(data.get("points"));
        final double distance = Convert.toDouble(data.get("distance"));
        final LinearUnitId distanceUnitId = Convert.toLinearUnitId(data.get("distanceUnit"));
        final double azimuth = Convert.toDouble(data.get("azimuth"));
        final AngularUnitId azimuthUnitId = Convert.toAngularUnitId(data.get("azimuthUnit"));
        final GeodeticCurveType curveType = Convert.toGeodeticCurveType(data.get("curveType"));

        final List<Point> points = new ArrayList<>();
        for (Object rawPoint : rawPoints) {
            points.add(Convert.toPoint(rawPoint));
        }

        final List<Point> movedPoints = GeometryEngine.moveGeodetic(points, distance, new LinearUnit(distanceUnitId), azimuth, new AngularUnit(azimuthUnitId), curveType);
        final List<Object> resultPoints = new ArrayList<>();
        for (Point point : movedPoints) {
            resultPoints.add(Convert.geometryToJson(point));
        }
        result.success(resultPoints);
    }

    private void handleIntersections(Map<?, ?> data, MethodChannel.Result result) {

        final Geometry firstGeometry = Convert.toGeometry(data.get("firstGeometry"));
        final Geometry secondGeometry = Convert.toGeometry(data.get("secondGeometry"));
        List<Geometry> geometryList = GeometryEngine.intersections(firstGeometry, secondGeometry);
        ArrayList<Object> resultList = new ArrayList<>();
        for (Geometry geometry : geometryList) {
            resultList.add(Convert.geometryToJson(geometry));
        }
        result.success(resultList);
    }

    private void handleIntersection(Map<?, ?> data, MethodChannel.Result result) {
        final Geometry firstGeometry = Convert.toGeometry(data.get("firstGeometry"));
        final Geometry secondGeometry = Convert.toGeometry(data.get("secondGeometry"));
        Geometry geometry = GeometryEngine.intersection(firstGeometry, secondGeometry);
        result.success(Convert.geometryToJson(geometry));
    }

    private void handleGeodeticBufferGeometry(Map<?, ?> data, MethodChannel.Result result) {
        final Geometry geometry = Convert.toGeometry(data.get("geometry"));
        final double distance = Convert.toDouble(data.get("distance"));
        final LinearUnitId distanceUnitId = Convert.toLinearUnitId(data.get("distanceUnit"));
        final double maxDeviation = Convert.toDouble(data.get("maxDeviation"));
        final GeodeticCurveType curveType = Convert.toGeodeticCurveType(data.get("curveType"));
        final Polygon polygon = GeometryEngine.bufferGeodetic(geometry, distance, new LinearUnit(distanceUnitId), maxDeviation, curveType);
        if (polygon == null) {
            result.success(null);
        } else {
            result.success(Convert.geometryToJson(polygon));
        }
    }

    private void handleBufferGeometry(Map<?, ?> data, MethodChannel.Result result) {
        final Geometry geometry = Convert.toGeometry(data.get("geometry"));
        final double distance = Convert.toDouble(data.get("distance"));
        final Polygon polygon = GeometryEngine.buffer(geometry, distance);
        if (polygon == null) {
            result.success(null);
        } else {
            result.success(Convert.geometryToJson(polygon));
        }
    }

    private void handleProject(Map<?, ?> data, MethodChannel.Result result) {
        final SpatialReference spatialReference = Convert.toSpatialReference(data.get("spatialReference"));
        final Geometry geometry = Convert.toGeometry(data.get("geometry"));
        final Geometry projectedGeometry = GeometryEngine.project(geometry, spatialReference);
        if (projectedGeometry == null) {
            result.success(null);
        } else {
            result.success(Convert.geometryToJson(projectedGeometry));
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

    private void handleSimply(Map<?, ?> data, MethodChannel.Result result) {
        Geometry originGeometry = Convert.toGeometry(data);
        if (originGeometry == null) {
            Log.e(TAG, "Failed to simply as geometry is null");
            result.success(null);
        } else {
            Geometry simplifiedGeometry = GeometryEngine.simplify(originGeometry);
            result.success(Convert.geometryToJson(simplifiedGeometry));
        }
    }

    private void handleIsSimple(Map<?, ?> data, MethodChannel.Result result) {
        Geometry originGeometry = Convert.toGeometry(data);
        if (originGeometry == null) {
            Log.e(TAG, "Failed to get isSimple as geometry is null");
            result.success(true);
        } else {
            result.success(GeometryEngine.isSimple(originGeometry));
        }
    }
}
