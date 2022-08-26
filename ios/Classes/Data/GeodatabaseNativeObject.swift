//
// Created by Valentin Grigorean on 26.08.2022.
//

import Foundation
import ArcGIS

class GeodatabaseNativeObject: BaseNativeObject<AGSGeodatabase> {

    init(objectId: String, geodatabase: AGSGeodatabase, messageSink: NativeMessageSink) {
        super.init(objectId: objectId, nativeObject: geodatabase, nativeHandlers: [
            LoadableNativeHandler(loadable: geodatabase)
        ], messageSink: messageSink)
    }

    override func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) {
        switch (method) {
        case "geodatabase#close":
            nativeObject.close();
            result(nil)
            break
        default:
            super.onMethodCall(method: method, arguments: arguments, result: result)
        }
    }
}