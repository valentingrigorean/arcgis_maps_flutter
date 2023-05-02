//
// Created by Valentin Grigorean on 26.08.2022.
//

import Foundation
import ArcGIS

class SyncGeodatabaseJobNativeObject: BaseNativeObject<SyncGeodatabaseJob> {
    init(objectId: String, job: SyncGeodatabaseJob, messageSink: NativeMessageSink) {
        super.init(objectId: objectId, nativeObject: job, nativeHandlers: [
            JobNativeHandler(job: job),
        ], messageSink: messageSink)
    }
    
    override func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) {
        switch (method) {
        case "syncGeodatabaseJob#getGeodatabaseDeltaInfo":
            result(nativeObject.geodatabaseDeltaInfo?.toJSONFlutter())
            break
        case "syncGeodatabaseJob#getResult":
            createTask {
                let jobResult = await self.nativeObject.result
                switch jobResult{
                case .success(let output):
                    result(output.map{ $0.toJSONFlutter()})
                    break
                case .failure(let error):
                    result(error.toJSONFlutter())
                }
                
            }
            break
        default:
            super.onMethodCall(method: method, arguments: arguments, result: result)
        }
    }
}
