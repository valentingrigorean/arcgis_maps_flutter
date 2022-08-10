//
// Created by Valentin Grigorean on 26.07.2022.
//

import Foundation
import ArcGIS

class ExportTileCacheJobNativeObject: BaseNativeObject<AGSExportTileCacheJob> {

    init(objectId: String, job: AGSExportTileCacheJob, messageSink: NativeObjectControllerMessageSink) {
        super.init(objectId: objectId, nativeObject: job, nativeHandlers: [
            JobNativeHandler(job: job),
            RemoteResourceNativeHandler(remoteResource: job)
        ], messageSink: messageSink)

    }
}