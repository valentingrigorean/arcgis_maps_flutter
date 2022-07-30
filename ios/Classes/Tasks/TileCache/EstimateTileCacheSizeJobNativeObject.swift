//
// Created by Valentin Grigorean on 25.07.2022.
//

import Foundation
import ArcGIS

class EstimateTileCacheSizeJobNativeObject: BaseNativeObject<AGSEstimateTileCacheSizeJob> {

    init(objectId: String, job: AGSEstimateTileCacheSizeJob, messageSink: NativeObjectControllerMessageSink) {
        super.init(objectId: objectId, nativeObject: job, nativeHandlers: [
            JobNativeHandler(job: job)
        ], messageSink: messageSink)
    }
}
