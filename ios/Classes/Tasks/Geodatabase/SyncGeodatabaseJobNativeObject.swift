//
// Created by Valentin Grigorean on 26.08.2022.
//

import Foundation
import ArcGIS

class SyncGeodatabaseJobNativeObject: BaseNativeObject<AGSSyncGeodatabaseJob> {
    init(objectId: String, job: AGSSyncGeodatabaseJob, messageSink: NativeMessageSink) {
        super.init(objectId: objectId, nativeObject: job, nativeHandlers: [
            JobNativeHandler(job: job),
            RemoteResourceNativeHandler(remoteResource: job)
        ], messageSink: messageSink)
    }

    override func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) {
        switch (method) {
        case "syncGeodatabaseJob#getGeodatabaseDeltaInfo":
            result(nativeObject.geodatabaseDeltaInfo?.toJSONFlutter())
            break
        case "syncGeodatabaseJob#getResult":
            result(nativeObject.result?.map({$0.toJSONFlutter()}))
            break
        default:
            super.onMethodCall(method: method, arguments: arguments, result: result)
        }
    }
}