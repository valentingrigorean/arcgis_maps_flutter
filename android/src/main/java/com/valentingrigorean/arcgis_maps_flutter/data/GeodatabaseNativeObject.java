package com.valentingrigorean.arcgis_maps_flutter.data;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.esri.arcgisruntime.data.Geodatabase;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.loadable.LoadableNativeHandler;

import io.flutter.plugin.common.MethodChannel;

public class GeodatabaseNativeObject extends BaseNativeObject<Geodatabase> {

    public GeodatabaseNativeObject(String objectId, Geodatabase geodatabase) {
        super(objectId, geodatabase, new NativeHandler[]{
                new LoadableNativeHandler(geodatabase)
        });
    }

    @Override
    public void onMethodCall(@NonNull String method, @Nullable Object args, @NonNull MethodChannel.Result result) {
        switch (method) {
            case "geodatabase#close":
                getNativeObject().close();
                result.success(null);
                break;
            default:
                super.onMethodCall(method, args, result);
                break;
        }
    }
}
