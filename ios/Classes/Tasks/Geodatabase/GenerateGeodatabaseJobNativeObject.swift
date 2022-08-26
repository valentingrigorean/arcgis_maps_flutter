//
// Created by Valentin Grigorean on 29.07.2022.
//

import Foundation
import ArcGIS

class GenerateGeodatabaseJobNativeObject: BaseNativeObject<AGSGenerateGeodatabaseJob> {
    init(objectId: String, job: AGSGenerateGeodatabaseJob, messageSink: NativeMessageSink) {
        super.init(objectId: objectId, nativeObject: job, nativeHandlers: [
            JobNativeHandler(job: job),
            RemoteResourceNativeHandler(remoteResource: job)
        ], messageSink: messageSink)
    }
}