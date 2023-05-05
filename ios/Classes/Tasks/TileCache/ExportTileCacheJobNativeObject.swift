//
// Created by Valentin Grigorean on 26.07.2022.
//

import Foundation
import ArcGIS

class ExportTileCacheJobNativeObject: BaseNativeObject<ExportTileCacheJob> {

    init(objectId: String, job: ExportTileCacheJob, messageSink: NativeMessageSink) {
        super.init(objectId: objectId, nativeObject: job, nativeHandlers: [
            JobNativeHandler(job: job),
        ], messageSink: messageSink)

    }
}
