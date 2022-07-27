//
// Created by Valentin Grigorean on 26.07.2022.
//

import Foundation
import ArcGIS

class TileCacheNativeObject: ArcgisNativeObjectController {
    let tileCache: AGSTileCache

    init(tileCache: AGSTileCache, objectId: String, messageSink: NativeObjectControllerMessageSink) {
        self.tileCache = tileCache
        super.init(objectId: objectId, nativeHandlers: [
            LoadableNativeHandler(loadable: tileCache)
        ], messageSink: messageSink)
    }

    override func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) {
        switch (method) {
        case "tileCache#getAntialiasing":
            result(tileCache.antialiasing)
            break
        case "tileCache#getCacheStorageFormat":
            result(tileCache.cacheStorageFormat.rawValue)
            break
        case "tileCache#getTileInfo":
            result(tileCache.tileInfo?.toJSONFlutter())
            break
        case "tileCache#getFullExtent":
            result(tileCache.fullExtent?.toJSONFlutter())
            break
        default:
            super.onMethodCall(method: method, arguments: arguments, result: result)
        }
    }
}