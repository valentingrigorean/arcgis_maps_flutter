package com.valentingrigorean.arcgis_maps_flutter.tasks.offlinemap

import com.arcgismaps.tasks.offlinemaptask.GenerateOfflineMapJob
import com.valentingrigorean.arcgis_maps_flutter.concurrent.JobNativeHandler
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject

class GenerateOfflineMapJobNativeObject(jobId: String, job: GenerateOfflineMapJob) :
    BaseNativeObject<GenerateOfflineMapJob>(
        jobId, job, arrayOf(
            JobNativeHandler(job),
        )
    )