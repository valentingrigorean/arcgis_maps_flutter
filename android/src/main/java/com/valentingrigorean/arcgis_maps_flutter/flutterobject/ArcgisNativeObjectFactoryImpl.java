package com.valentingrigorean.arcgis_maps_flutter.flutterobject;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.esri.arcgisruntime.data.TileCache;
import com.esri.arcgisruntime.mapping.ArcGISMap;
import com.esri.arcgisruntime.portal.PortalItem;
import com.esri.arcgisruntime.tasks.geodatabase.GeodatabaseSyncTask;
import com.esri.arcgisruntime.tasks.offlinemap.OfflineMapTask;
import com.esri.arcgisruntime.tasks.tilecache.ExportTileCacheTask;
import com.valentingrigorean.arcgis_maps_flutter.Convert;
import com.valentingrigorean.arcgis_maps_flutter.data.TileCacheNativeObject;
import com.valentingrigorean.arcgis_maps_flutter.tasks.geodatabase.GeodatabaseSyncTaskNativeObject;
import com.valentingrigorean.arcgis_maps_flutter.tasks.offlinemap.OfflineMapSyncTaskNativeObject;
import com.valentingrigorean.arcgis_maps_flutter.tasks.offlinemap.OfflineMapTaskNativeObject;
import com.valentingrigorean.arcgis_maps_flutter.tasks.tilecache.ExportTileCacheTaskNativeObject;

import java.util.Map;
import java.util.Objects;

public class ArcgisNativeObjectFactoryImpl implements ArcgisNativeObjectFactory {

    @NonNull
    @Override
    public NativeObject createNativeObject(@NonNull String objectId, @NonNull String type, @Nullable Object arguments, @NonNull NativeMessageSink messageSink) {
        switch (type) {
            case "ExportTileCacheTask": {
                final String url = (String) arguments;
                final ExportTileCacheTask exportTileCacheTask = new ExportTileCacheTask(Objects.requireNonNull(url));
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
            case "GeodatabaseSyncTask": {
                final String url = (String) arguments;
                final GeodatabaseSyncTask geodatabaseSyncTask = new GeodatabaseSyncTask(Objects.requireNonNull(url));
                final NativeObject nativeObject = new GeodatabaseSyncTaskNativeObject(objectId, geodatabaseSyncTask);
                nativeObject.setMessageSink(messageSink);
                return nativeObject;
            }
            case "OfflineMapTask": {
                final OfflineMapTask task = createOfflineMapTask(Convert.toMap(arguments));
                final NativeObject nativeObject = new OfflineMapTaskNativeObject(objectId, task);
                nativeObject.setMessageSink(messageSink);
                return nativeObject;
            }
            case "OfflineMapSyncTask": {
                final OfflineMapSyncTaskNativeObject nativeObject = new OfflineMapSyncTaskNativeObject(objectId, arguments.toString());
                nativeObject.setMessageSink(messageSink);
                return nativeObject;
            }
            default:
                throw new RuntimeException("Not implemented");
        }
    }

    private static OfflineMapTask createOfflineMapTask(Map<?, ?> data) {
        OfflineMapTask offlineMapTask;
        final Object arcgisMap = data.get("map");
        final Object portalItem = data.get("portalItem");
        if (arcgisMap != null) {
            ArcGISMap arcGISMap = Convert.toArcGISMap(arcgisMap);
            offlineMapTask = new OfflineMapTask(arcGISMap);
        } else if (portalItem != null) {
            final PortalItem nativePortalItem = Convert.toPortalItem(portalItem);
            offlineMapTask = new OfflineMapTask(nativePortalItem);
        } else {
            throw new IllegalArgumentException("Map or PortalItem is required");
        }

        return offlineMapTask;
    }
}
