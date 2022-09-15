package com.valentingrigorean.arcgis_maps_flutter.data;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.esri.arcgisruntime.data.TileCache;
import com.esri.arcgisruntime.geometry.Envelope;
import com.valentingrigorean.arcgis_maps_flutter.Convert;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.loadable.LoadableNativeHandler;

import io.flutter.plugin.common.MethodChannel;

public class TileCacheNativeObject extends BaseNativeObject<TileCache> {

    public TileCacheNativeObject(String objectId, TileCache tileCache) {
        super(objectId, tileCache, new NativeHandler[]{
                new LoadableNativeHandler(tileCache)
        });
    }


    @Override
    public void onMethodCall(@NonNull String method, @Nullable Object args, @NonNull MethodChannel.Result result) {
        switch (method) {
            case "tileCache#getAntialiasing":
                result.success(getNativeObject().isAntialiasing());
                break;
            case "tileCache#getCacheStorageFormat":
                result.success(getNativeObject().getCacheStorageFormat() == TileCache.StorageFormat.UNKNOWN ? -1 : getNativeObject().getCacheStorageFormat().ordinal());
                break;
            case "tileCache#getFullExtent":
                final Envelope envelope = getNativeObject().getFullExtent();
                result.success(envelope == null ? null : Convert.geometryToJson(envelope));
                break;
            default:
                super.onMethodCall(method, args, result);
                break;
        }

    }
}
