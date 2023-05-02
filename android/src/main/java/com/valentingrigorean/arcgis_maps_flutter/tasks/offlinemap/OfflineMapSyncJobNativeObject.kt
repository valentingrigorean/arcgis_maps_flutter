package com.valentingrigorean.arcgis_maps_flutter.tasks.offlinemap

import com.esri.arcgisruntime.tasks.offlinemap.OfflineMapSyncJob
import com.valentingrigorean.arcgis_maps_flutter.concurrent.JobNativeHandler
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler
import com.valentingrigorean.arcgis_maps_flutter.io.RemoteResourceNativeHandler
import com.valentingrigorean.arcgis_maps_flutter.convert.geodatabase.ConvertGeodatabase
import io.flutter.plugin.common.MethodChannel

class OfflineMapSyncJobNativeObject(objectId: String?, job: OfflineMapSyncJob) :
    BaseNativeObject<OfflineMapSyncJob?>(
        objectId, job, arrayOf<NativeHandler>(
            JobNativeHandler(job, JobNativeHandler.JobType.OFFLINE_MAP_SYNC),
            RemoteResourceNativeHandler(job)
        )
    ) {
    override fun onMethodCall(method: String, args: Any?, result: MethodChannel.Result) {
        when (method) {
            "offlineMapSyncJob#getGeodatabaseDeltaInfos" -> {
                val geodatabaseDeltaInfos = nativeObject.getGeodatabaseDeltaInfos()
                val list = ArrayList<Any?>(geodatabaseDeltaInfos.size)
                for (geodatabaseDeltaInfo in geodatabaseDeltaInfos) {
                    list.add(ConvertGeodatabase.geodatabaseDeltaInfoToJson(geodatabaseDeltaInfo))
                }
                result.success(list)
            }

            "offlineMapSyncJob#getResult" -> {
                val syncResult = nativeObject.getResult()
                if (syncResult != null) {
                    result.success(ConvertOfflineMap.offlineMapSyncResultToJson(syncResult))
                } else {
                    result.success(null)
                }
            }

            else -> super.onMethodCall(method, args, result)
        }
    }
}