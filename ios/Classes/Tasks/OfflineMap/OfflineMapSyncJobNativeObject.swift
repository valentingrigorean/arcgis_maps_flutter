//
// Created by Valentin Grigorean on 23.08.2022.
//

import Foundation
import ArcGIS

class OfflineMapSyncJobNativeObject: BaseNativeObject<OfflineMapSyncJob> {
    init(objectId: String, job: OfflineMapSyncJob, messageSink: NativeMessageSink) {
        super.init(objectId: objectId, nativeObject: job, nativeHandlers: [
            JobNativeHandler(job: job),
        ], messageSink: messageSink)
    }

    override func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) {
        switch method {
        case "offlineMapSyncJob#getGeodatabaseDeltaInfos":
            result(nativeObject.geodatabaseDeltaInfos.map {
                $0.toJSONFlutter()
            })
            break
        case "offlineMapSyncJob#getResult":
            createTask {
                do{
                    let jobResult = try await self.nativeObject.result.get()
                    result(jobResult.toJSONFlutter())
                }catch{
                    result(nil)
                }
            }
            break
        default:
            super.onMethodCall(method: method, arguments: arguments, result: result)
        }
    }
}
