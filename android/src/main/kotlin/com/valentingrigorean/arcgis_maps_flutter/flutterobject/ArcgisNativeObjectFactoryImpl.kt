package com.valentingrigorean.arcgis_maps_flutter.flutterobject

import com.arcgismaps.data.Geodatabase
import com.arcgismaps.data.ServiceFeatureTable
import com.arcgismaps.mapping.MobileMapPackage
import com.arcgismaps.mapping.layers.TileCache
import com.arcgismaps.tasks.geocode.LocatorTask
import com.arcgismaps.tasks.geodatabase.GeodatabaseSyncTask
import com.arcgismaps.tasks.networkanalysis.RouteTask
import com.arcgismaps.tasks.offlinemaptask.OfflineMapSyncTask
import com.arcgismaps.tasks.offlinemaptask.OfflineMapTask
import com.arcgismaps.tasks.tilecache.ExportTileCacheTask
import com.valentingrigorean.arcgis_maps_flutter.convert.mapping.toArcGISMapOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.mapping.toPortalItemOrNull
import com.valentingrigorean.arcgis_maps_flutter.data.GeodatabaseNativeObject
import com.valentingrigorean.arcgis_maps_flutter.data.ServiceFeatureTableNativeObject
import com.valentingrigorean.arcgis_maps_flutter.data.TileCacheNativeObject
import com.valentingrigorean.arcgis_maps_flutter.tasks.geocode.LocatorTaskNativeObject
import com.valentingrigorean.arcgis_maps_flutter.tasks.geodatabase.GeodatabaseSyncTaskNativeObject
import com.valentingrigorean.arcgis_maps_flutter.tasks.networkanalysis.RouteTaskNativeObject
import com.valentingrigorean.arcgis_maps_flutter.tasks.offlinemap.OfflineMapSyncTaskNativeObject
import com.valentingrigorean.arcgis_maps_flutter.tasks.offlinemap.OfflineMapTaskNativeObject
import com.valentingrigorean.arcgis_maps_flutter.tasks.tilecache.ExportTileCacheTaskNativeObject
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.withContext
import java.util.Objects

class ArcgisNativeObjectFactoryImpl(
    private val scope: CoroutineScope,
) : ArcgisNativeObjectFactory {


    override suspend fun createNativeObject(
        objectId: String,
        type: String,
        arguments: Any?,
        messageSink: NativeMessageSink
    ): Result<NativeObject> {
        return when (type) {
            "ExportTileCacheTask" -> {
                val url = arguments as String
                val exportTileCacheTask = ExportTileCacheTask(
                    Objects.requireNonNull(url)
                )
                val nativeObject: NativeObject =
                    ExportTileCacheTaskNativeObject(objectId, exportTileCacheTask)
                nativeObject.setMessageSink(messageSink)
                Result.success(nativeObject)
            }

            "TileCache" -> {
                val url = arguments as String
                val tileCache = TileCache(url)
                val nativeObject: NativeObject =
                    TileCacheNativeObject(objectId, tileCache)
                nativeObject.setMessageSink(messageSink)
                Result.success(nativeObject)
            }

            "GeodatabaseSyncTask" -> {
                val url = arguments as String
                val geodatabaseSyncTask = GeodatabaseSyncTask(
                    url
                )
                val nativeObject: NativeObject =
                    GeodatabaseSyncTaskNativeObject(objectId, geodatabaseSyncTask)
                nativeObject.setMessageSink(messageSink)
                Result.success(nativeObject)
            }

            "OfflineMapTask" -> {
                val task = createOfflineMapTask(
                    arguments as Map<*, *>
                )
                val nativeObject: NativeObject =
                    OfflineMapTaskNativeObject(objectId, task)
                nativeObject.setMessageSink(messageSink)
                Result.success(nativeObject)
            }

            "OfflineMapSyncTask" -> {
                try {
                    val offlinePath = arguments as String
                    val mobilePack = MobileMapPackage(offlinePath)
                    val result = withContext(scope.coroutineContext) {
                        mobilePack.load()
                    }
                    if (result.isSuccess) {
                        val nativeObject = OfflineMapSyncTaskNativeObject(
                            objectId,
                            OfflineMapSyncTask(mobilePack.maps[0])
                        )
                        nativeObject.setMessageSink(messageSink)
                        Result.success(nativeObject)
                    } else {
                        Result.failure(
                            result.exceptionOrNull() ?: Exception("Failed to load the map.")
                        )
                    }
                } catch (e: Exception) {
                    Result.failure(e)
                }
            }


            "Geodatabase" -> {
                val url = arguments as String
                val nativeObject: NativeObject =
                    GeodatabaseNativeObject(objectId, Geodatabase(url))
                nativeObject.setMessageSink(messageSink)
                Result.success(nativeObject)
            }

            "RouteTask" -> {
                val url = arguments as String
                val routeTask = RouteTask(
                    url
                )
                val nativeObject: NativeObject =
                    RouteTaskNativeObject(objectId, routeTask)
                nativeObject.setMessageSink(messageSink)
                Result.success(nativeObject)
            }

            "LocatorTask" -> {
                val url = arguments as String
                val locatorTask = LocatorTask(url)
                val nativeObject: NativeObject =
                    LocatorTaskNativeObject(objectId, locatorTask)
                nativeObject.setMessageSink(messageSink)
                Result.success(nativeObject)
            }

            "ServiceFeatureTable" -> {
                val url = arguments as String
                val serviceFeatureTable = ServiceFeatureTable(url)
                val nativeObject: NativeObject =
                    ServiceFeatureTableNativeObject(objectId, serviceFeatureTable)
                nativeObject.setMessageSink(messageSink)
                Result.success(nativeObject)
            }

            else -> Result.failure(throw RuntimeException("Not implemented"))
        }
    }

    private fun createOfflineMapTask(data: Map<*, *>): OfflineMapTask {
        val offlineMapTask: OfflineMapTask
        val arcgisMap = data["map"]
        val portalItem = data["portalItem"]
        offlineMapTask = if (arcgisMap != null) {
            val arcGISMap = arcgisMap.toArcGISMapOrNull()!!
            OfflineMapTask(arcGISMap)
        } else if (portalItem != null) {
            val nativePortalItem = portalItem.toPortalItemOrNull()!!
            OfflineMapTask(nativePortalItem)
        } else {
            throw IllegalArgumentException("Map or PortalItem is required")
        }
        return offlineMapTask
    }
}

