//
// Created by Valentin Grigorean on 26.07.2022.
//

import Foundation
import ArcGIS

class ExportTileCacheJobNativeObject : ArcgisNativeObjectController {

    let job: AGSExportTileCacheJob

    init(job: AGSExportTileCacheJob, objectId: String, messageSink: NativeObjectControllerMessageSink) {
        self.job = job
        super.init(objectId: objectId, nativeHandlers: [
            JobNativeHandler(job: job)
        ], messageSink: messageSink)

    }
}