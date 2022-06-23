package com.valentingrigorean.arcgis_maps_flutter.geometry;

import androidx.annotation.NonNull;


import com.esri.arcgisruntime.geometry.CoordinateFormatter;
import com.esri.arcgisruntime.geometry.Point;
import com.valentingrigorean.arcgis_maps_flutter.Convert;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class CoordinateFormatterController implements MethodChannel.MethodCallHandler {
    private static final String TAG = "CoordinateFormatterController";
    private final MethodChannel channel;

    public CoordinateFormatterController(BinaryMessenger messenger) {
        channel = new MethodChannel(messenger, "plugins.flutter.io/arcgis_channel/coordinate_formatter");
        channel.setMethodCallHandler(this);
    }

    public void dispose() {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "latitudeLongitudeString":
                final Map<?, ?> data = Convert.toMap(call.arguments);
                final Point from = (Point) Convert.toGeometry(data.get("from"));
                final int format = Convert.toInt(data.get("format"));
                final int decimalPlaces = Convert.toInt(data.get("decimalPlaces"));
                result.success(CoordinateFormatter.toLatitudeLongitude(from, CoordinateFormatter.LatitudeLongitudeFormat.values()[format], decimalPlaces));
                break;
            default:
                result.notImplemented();
                break;
        }
    }
}
