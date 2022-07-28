package com.valentingrigorean.arcgis_maps_flutter.flutterobject;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.esri.arcgisruntime.data.TileCache;
import com.esri.arcgisruntime.tasks.tilecache.ExportTileCacheTask;
import com.valentingrigorean.arcgis_maps_flutter.data.TileCacheNativeObject;
import com.valentingrigorean.arcgis_maps_flutter.tasks.tilecache.ExportTileCacheTaskNativeObject;

public class ArcgisNativeObjectFactoryImpl implements ArcgisNativeObjectFactory {

    @NonNull
    @Override
    public NativeObject createNativeObject(@NonNull String objectId, @NonNull String type, @Nullable Object arguments, @NonNull ArcgisNativeObjectsController.NativeObjectControllerMessageSink messageSink) {
        switch (type) {
            case "ExportTileCacheTask": {
                final String url = (String) arguments;
                final ExportTileCacheTask exportTileCacheTask = new ExportTileCacheTask(url);
                final NativeObject nativeObject = new ExportTileCacheTaskNativeObject(objectId, exportTileCacheTask);
                nativeObject.setMessageSink(messageSink);
                return nativeObject;
            }
            case "TileCache": {
                final String url = (String) arguments;
                final TileCache tileCache = new TileCache(url);
                final NativeObject nativeObject = new TileCacheNativeObject(objectId, tileCache);
                nativeObject.setMessageSink(messageSink);
                return nativeObject;
            }
            default:
                throw new RuntimeException("Not implemented");
        }
    }
}
