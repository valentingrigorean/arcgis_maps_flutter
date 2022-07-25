//
// Created by Valentin Grigorean on 25.07.2022.
//

import Foundation
import ArcGIS

class EstimateTileCacheSizeJobNativeObject: ArcgisNativeObjectController {

    let estimateTileCacheSizeJob: AGSEstimateTileCacheSizeJob

    init(estimateTileCacheSizeJob: AGSEstimateTileCacheSizeJob, objectId: String, messageSink: NativeMessageSink) {
        self.estimateTileCacheSizeJob = estimateTileCacheSizeJob
        super.init(objectId: objectId, nativeHandlers: [
            JobNativeHandler(job: estimateTileCacheSizeJob)
        ], messageSink: messageSink)

    }
}
