//
// Created by Valentin Grigorean on 26.07.2022.
//

import Foundation
import ArcGIS

class TileCacheNativeObject : ArcgisNativeObjectController{
    let tileCache: AGSTileCache

    init(tileCache:AGSTileCache, objectId: String, messageSink: NativeObjectControllerMessageSink) {
        self.tileCache = tileCache
        super.init(objectId: objectId, nativeHandlers: [
            LoadableNativeHandler(loadable: tileCache)
        ], messageSink: messageSink)
    }
}