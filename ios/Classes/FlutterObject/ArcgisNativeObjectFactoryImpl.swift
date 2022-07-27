//
// Created by Valentin Grigorean on 25.07.2022.
//

import Foundation
import ArcGIS

class ArcgisNativeObjectFactoryImpl: ArcgisNativeObjectFactory {
    func createNativeObject(objectId: String, type: String, arguments: Any?, messageSink: NativeObjectControllerMessageSink) -> ArcgisNativeObjectController {
        switch (type) {
        case "ExportTileCacheTask":
            let url = arguments as! String
            let exportTileCacheTask = AGSExportTileCacheTask(url: URL(string: url)!)
            return ExportTileCacheTaskNativeObject(objectId: objectId, exportTileCacheTask: exportTileCacheTask, messageSink: messageSink)
        case "TileCache":
            let url = arguments as! String
            return TileCacheNativeObject(tileCache: AGSTileCache(name: url), objectId: objectId, messageSink: messageSink)
        default:
            fatalError("Not implemented.")
        }
    }
}