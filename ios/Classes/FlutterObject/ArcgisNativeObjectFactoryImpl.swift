//
// Created by Valentin Grigorean on 25.07.2022.
//

import Foundation
import ArcGIS

class ArcgisNativeObjectFactoryImpl: ArcgisNativeObjectFactory {
    func createNativeObject(objectId: String, type: String, arguments: Any?, messageSink: NativeObjectControllerMessageSink) -> NativeObject {
        switch (type) {
        case "ExportTileCacheTask":
            let url = arguments as! String
            let exportTileCacheTask = AGSExportTileCacheTask(url: URL(string: url)!)
            return ExportTileCacheTaskNativeObject(objectId: objectId, task: exportTileCacheTask, messageSink: messageSink)
        case "TileCache":
            let url = arguments as! String
            return TileCacheNativeObject(objectId: objectId, tileCache: AGSTileCache(name: url), messageSink: messageSink)
        case "GeodatabaseSyncTask":
            let url = arguments as! String
            return GeodatabaseSyncTaskNativeObject(objectId: objectId, task: AGSGeodatabaseSyncTask(url: URL(string: url)!), messageSink: messageSink)
        default:
            fatalError("Not implemented.")
        }
    }
}