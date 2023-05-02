package com.valentingrigorean.arcgis_maps_flutter.tasks.offlinemap

import com.esri.arcgisruntime.tasks.offlinemap.GenerateOfflineMapJob
import com.valentingrigorean.arcgis_maps_flutter.concurrent.JobNativeHandler
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler

class GenerateOfflineMapJobNativeObject(jobId: String?, job: GenerateOfflineMapJob) :
    BaseNativeObject<GenerateOfflineMapJob?>(
        jobId, job, arrayOf<NativeHandler>(
            JobNativeHandler(job, JobNativeHandler.JobType.GENERATE_OFFLINE_MAP),
            RemoteResourceNativeHandler(job)
        )
    )