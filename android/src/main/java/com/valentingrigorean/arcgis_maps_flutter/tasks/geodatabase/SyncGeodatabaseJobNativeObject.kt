package com.valentingrigorean.arcgis_maps_flutter.tasks.geodatabase

import com.arcgismaps.tasks.geodatabase.SyncGeodatabaseJob
import com.valentingrigorean.arcgis_maps_flutter.concurrent.JobNativeHandler
import com.valentingrigorean.arcgis_maps_flutter.convert.geodatabase.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.launch

class SyncGeodatabaseJobNativeObject(objectId: String, job: SyncGeodatabaseJob) :
    BaseNativeObject<SyncGeodatabaseJob>(
        objectId, job, arrayOf(
            JobNativeHandler(job),
        )
    ) {
    override fun onMethodCall(method: String, args: Any?, result: MethodChannel.Result) {
        when (method) {
            "syncGeodatabaseJob#getGeodatabaseDeltaInfo" -> {
                val deltaInfo = nativeObject.geodatabaseDeltaInfo
                if (deltaInfo == null) {
                    result.success(null)
                } else {
                    result.success(deltaInfo.toFlutterJson())
                }
            }

            "syncGeodatabaseJob#getResult" -> {
                scope.launch {
                    nativeObject.result().onSuccess { results ->
                        result.success(results.map { it.toFlutterJson() })
                    }.onFailure {
                        result.success(it.toFlutterJson())
                    }
                }
            }

            else -> super.onMethodCall(method, args, result)
        }
    }
}