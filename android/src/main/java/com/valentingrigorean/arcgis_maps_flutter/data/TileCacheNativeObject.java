package com.valentingrigorean.arcgis_maps_flutter.data;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.esri.arcgisruntime.data.TileCache;
import com.esri.arcgisruntime.geometry.Envelope;
import com.valentingrigorean.arcgis_maps_flutter.Convert;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.ArcgisNativeObjectController;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.ArcgisNativeObjectsController;
import com.valentingrigorean.arcgis_maps_flutter.loadable.LoadableNativeHandler;

import io.flutter.plugin.common.MethodChannel;

public class TileCacheNativeObject extends ArcgisNativeObjectController {
    final private TileCache tileCache;

    public TileCacheNativeObject(TileCache tileCache, String objectId, ArcgisNativeObjectsController.NativeObjectControllerMessageSink messageSink) {
        super(objectId, new NativeHandler[]{
                new LoadableNativeHandler(tileCache)
        }, messageSink);
        this.tileCache = tileCache;
    }

    public TileCache getTileCache() {
        return tileCache;
    }

    @Override
    public void onMethodCall(@NonNull String method, @Nullable Object args, @NonNull MethodChannel.Result result) {
        switch (method) {
            case "tileCache#getAntialiasing":
                result.success(tileCache.isAntialiasing());
                break;
            case "tileCache#getCacheStorageFormat":
                result.success(tileCache.getCacheStorageFormat() == TileCache.StorageFormat.UNKNOWN ? -1 : tileCache.getCacheStorageFormat().ordinal());
                break;
            case "tileCache#getFullExtent":
                final Envelope envelope = tileCache.getFullExtent();
                result.success(envelope == null ? null : Convert.geometryToJson(envelope));
                break;
            default:
                super.onMethodCall(method, args, result);
                break;
        }

    }
}
