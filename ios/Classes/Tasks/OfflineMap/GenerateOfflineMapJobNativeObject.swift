//
// Created by Valentin Grigorean on 24.06.2022.
//

import Foundation
import ArcGIS

class GenerateOfflineMapJobNativeObject: BaseNativeObject<GenerateOfflineMapJob> {
    init(objectId: String, job: GenerateOfflineMapJob, messageSink: NativeMessageSink) {
        super.init(objectId: objectId, nativeObject: job, nativeHandlers: [
            JobNativeHandler(job: job),
        ], messageSink: messageSink)
    }
}
