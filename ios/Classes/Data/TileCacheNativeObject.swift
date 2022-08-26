//
// Created by Valentin Grigorean on 26.07.2022.
//

import Foundation
import ArcGIS

class TileCacheNativeObject: BaseNativeObject<AGSTileCache> {

    init(objectId: String, tileCache: AGSTileCache, messageSink: NativeMessageSink) {
        super.init(objectId: objectId,nativeObject: tileCache, nativeHandlers: [
            LoadableNativeHandler(loadable: tileCache)
        ], messageSink: messageSink)
    }

    override func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) {
        switch (method) {
        case "tileCache#getAntialiasing":
            result(nativeObject.antialiasing)
            break
        case "tileCache#getCacheStorageFormat":
            result(nativeObject.cacheStorageFormat.rawValue)
            break
        case "tileCache#getTileInfo":
            result(nativeObject.tileInfo?.toJSONFlutter())
            break
        case "tileCache#getFullExtent":
            result(nativeObject.fullExtent?.toJSONFlutter())
            break
        default:
            super.onMethodCall(method: method, arguments: arguments, result: result)
        }
    }
}