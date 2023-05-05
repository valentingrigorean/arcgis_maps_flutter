//
// Created by Valentin Grigorean on 25.07.2022.
//

import Foundation
import ArcGIS

class EstimateTileCacheSizeJobNativeObject: BaseNativeObject<EstimateTileCacheSizeJob> {

    init(objectId: String, job: EstimateTileCacheSizeJob, messageSink: NativeMessageSink) {
        super.init(objectId: objectId, nativeObject: job, nativeHandlers: [
            JobNativeHandler(job: job),
        ], messageSink: messageSink)
    }
}
