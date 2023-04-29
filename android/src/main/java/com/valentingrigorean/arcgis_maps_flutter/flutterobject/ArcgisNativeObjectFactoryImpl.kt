package com.valentingrigorean.arcgis_maps_flutter.flutterobject

import com.arcgismaps.data.Geodatabase
import com.arcgismaps.mapping.ArcGISMap
import com.arcgismaps.mapping.PortalItem
import com.arcgismaps.mapping.layers.TileCache
import com.arcgismaps.tasks.geocode.LocatorTask
import com.arcgismaps.tasks.geodatabase.GeodatabaseSyncTask
import com.arcgismaps.tasks.networkanalysis.RouteTask
import com.arcgismaps.tasks.offlinemaptask.OfflineMapTask
import com.arcgismaps.tasks.tilecache.ExportTileCacheTask
import com.valentingrigorean.arcgis_maps_flutter.Convert
import com.valentingrigorean.arcgis_maps_flutter.data.GeodatabaseNativeObject
import com.valentingrigorean.arcgis_maps_flutter.data.TileCacheNativeObject
import com.valentingrigorean.arcgis_maps_flutter.tasks.geocode.LocatorTaskNativeObject
import com.valentingrigorean.arcgis_maps_flutter.tasks.geodatabase.GeodatabaseSyncTaskNativeObject
import com.valentingrigorean.arcgis_maps_flutter.tasks.networkanalysis.RouteTaskNativeObject
import com.valentingrigorean.arcgis_maps_flutter.tasks.offlinemap.OfflineMapSyncTaskNativeObject
import com.valentingrigorean.arcgis_maps_flutter.tasks.offlinemap.OfflineMapTaskNativeObject
import com.valentingrigorean.arcgis_maps_flutter.tasks.tilecache.ExportTileCacheTaskNativeObject
import java.util.Objects

class ArcgisNativeObjectFactoryImpl() : ArcgisNativeObjectFactory {
    override fun createNativeObject(
        objectId: String,
        type: String,
        arguments: Any?,
        messageSink: NativeMessageSink
    ): NativeObject {
        return when (type) {
            "ExportTileCacheTask" -> {
                val url = arguments as String
                val exportTileCacheTask = ExportTileCacheTask(
                    Objects.requireNonNull(url)
                )
                val nativeObject: NativeObject =
                    ExportTileCacheTaskNativeObject(objectId, exportTileCacheTask)
                nativeObject.setMessageSink(messageSink)
                nativeObject
            }

            "TileCache" -> {
                val url = arguments as String
                val tileCache = TileCache(url)
                val nativeObject: NativeObject =
                    TileCacheNativeObject(objectId, tileCache)
                nativeObject.setMessageSink(messageSink)
                nativeObject
            }

            "GeodatabaseSyncTask" -> {
                val url = arguments as String
                val geodatabaseSyncTask = GeodatabaseSyncTask(
                    url
                )
                val nativeObject: NativeObject =
                    GeodatabaseSyncTaskNativeObject(objectId, geodatabaseSyncTask)
                nativeObject.setMessageSink(messageSink)
                nativeObject
            }

            "OfflineMapTask" -> {
                val task = createOfflineMapTask(
                    Convert.toMap(
                        arguments!!
                    )
                )
                val nativeObject: NativeObject =
                    OfflineMapTaskNativeObject(objectId, task)
                nativeObject.setMessageSink(messageSink)
                nativeObject
            }

            "OfflineMapSyncTask" -> {
                val nativeObject = OfflineMapSyncTaskNativeObject(objectId, arguments.toString())
                nativeObject.setMessageSink(messageSink)
                nativeObject
            }

            "Geodatabase" -> {
                val url = arguments as String
                val nativeObject: NativeObject =
                    GeodatabaseNativeObject(objectId, Geodatabase(url))
                nativeObject.setMessageSink(messageSink)
                nativeObject
            }

            "RouteTask" -> {
                val url = arguments as String
                val routeTask = RouteTask(
                    url
                )
                val nativeObject: NativeObject =
                    RouteTaskNativeObject(objectId, routeTask)
                nativeObject.setMessageSink(messageSink)
                nativeObject
            }

            "LocatorTask" -> {
                val url = arguments as String
                val locatorTask = LocatorTask(url)
                val nativeObject: NativeObject =
                    LocatorTaskNativeObject(objectId, locatorTask)
                nativeObject.setMessageSink(messageSink)
                nativeObject
            }

            else -> throw RuntimeException("Not implemented")
        }
    }

    companion object {
        private fun createOfflineMapTask(data: Map<*, *>): OfflineMapTask {
            val offlineMapTask: OfflineMapTask
            val arcgisMap = data["map"]
            val portalItem = data["portalItem"]
            offlineMapTask = if (arcgisMap != null) {
                val arcGISMap: ArcGISMap =
                    Convert.Companion.toArcGISMap(arcgisMap)
                OfflineMapTask(arcGISMap)
            } else if (portalItem != null) {
                val nativePortalItem: PortalItem =
                    Convert.Companion.toPortalItem(portalItem)
                OfflineMapTask(nativePortalItem)
            } else {
                throw IllegalArgumentException("Map or PortalItem is required")
            }
            return offlineMapTask
        }
    }
}