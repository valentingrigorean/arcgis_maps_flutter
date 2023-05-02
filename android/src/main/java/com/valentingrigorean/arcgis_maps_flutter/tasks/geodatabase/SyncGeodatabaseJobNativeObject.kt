package com.valentingrigorean.arcgis_maps_flutter.tasks.geodatabase

import com.esri.arcgisruntime.tasks.geodatabase.SyncGeodatabaseJob
import com.valentingrigorean.arcgis_maps_flutter.concurrent.JobNativeHandler
import com.valentingrigorean.arcgis_maps_flutter.convert.geodatabase.ConvertGeodatabase
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler
import com.valentingrigorean.arcgis_maps_flutter.io.RemoteResourceNativeHandler
import io.flutter.plugin.common.MethodChannel

class SyncGeodatabaseJobNativeObject(objectId: String?, job: SyncGeodatabaseJob) :
    BaseNativeObject<SyncGeodatabaseJob?>(
        objectId, job, arrayOf<NativeHandler>(
            JobNativeHandler(job, JobNativeHandler.JobType.SYNC_GEO_DATABASE),
            RemoteResourceNativeHandler(job)
        )
    ) {
    override fun onMethodCall(method: String, args: Any?, result: MethodChannel.Result) {
        when (method) {
            "syncGeodatabaseJob#getGeodatabaseDeltaInfo" -> {
                val deltaInfo = nativeObject.getGeodatabaseDeltaInfo()
                if (deltaInfo == null) {
                    result.success(null)
                } else {
                    result.success(ConvertGeodatabase.geodatabaseDeltaInfoToJson(deltaInfo))
                }
            }

            "syncGeodatabaseJob#getResult" -> {
                val syncResults = nativeObject.getResult()
                if (syncResults == null) {
                    result.success(null)
                } else {
                    result.success(ConvertGeodatabase.syncLayerResultsToJson(syncResults))
                }
            }

            else -> super.onMethodCall(method, args, result)
        }
    }
}