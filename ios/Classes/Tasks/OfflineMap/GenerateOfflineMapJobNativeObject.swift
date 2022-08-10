//
// Created by Valentin Grigorean on 24.06.2022.
//

import Foundation
import ArcGIS

class GenerateOfflineMapJobNativeObject: BaseNativeObject<AGSGenerateOfflineMapJob> {
    init(objectId: String, job: AGSGenerateOfflineMapJob, messageSink: NativeObjectControllerMessageSink) {
        super.init(objectId: objectId, nativeObject: job, nativeHandlers: [
            JobNativeHandler(job: job),
            RemoteResourceNativeHandler(remoteResource: job)
        ], messageSink: messageSink)
    }
}
