//
// Created by Valentin Grigorean on 25.07.2022.
//

import Foundation
import ArcGIS

class EstimateTileCacheSizeJobNativeObject: ArcgisNativeObjectController {

    private var status: AGSJobStatus
    let job: AGSEstimateTileCacheSizeJob

    init(job: AGSEstimateTileCacheSizeJob, objectId: String, messageSink: NativeObjectControllerMessageSink) {
        self.job = job
        status = job.status
        super.init(objectId: objectId, nativeHandlers: [
            JobNativeHandler(job: job)
        ], messageSink: messageSink)
    }
}
