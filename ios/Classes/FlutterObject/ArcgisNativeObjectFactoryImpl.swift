//
// Created by Valentin Grigorean on 25.07.2022.
//

import Foundation
import ArcGIS

class ArcgisNativeObjectFactoryImpl: ArcgisNativeObjectFactory {
    func createNativeObject(objectId: String, type: String, arguments: Any?, messageSink: NativeMessageSink) -> NativeObject {
        switch (type) {
        case "ExportTileCacheTask":
            let url = arguments as! String
            let exportTileCacheTask = ExportTileCacheTask(url: URL(string: url)!)
            return ExportTileCacheTaskNativeObject(objectId: objectId, task: exportTileCacheTask, messageSink: messageSink)
        case "TileCache":
            let url = arguments as! String
            return TileCacheNativeObject(objectId: objectId, tileCache: TileCache(name: url), messageSink: messageSink)
        case "GeodatabaseSyncTask":
            let url = arguments as! String
            return GeodatabaseSyncTaskNativeObject(objectId: objectId, task: GeodatabaseSyncTask(url: URL(string: url)!), messageSink: messageSink)
        case "OfflineMapTask":
            let task = createOfflineMapTask(data: arguments as! [String: Any])
            return OfflineMapTaskNativeObject(objectId: objectId, task: task, messageSink: messageSink)
        case "OfflineMapSyncTask":
            return OfflineMapSyncTaskNativeObject(objectId: objectId, offlineMapPath: arguments as! String, messageSink: messageSink)
        case "Geodatabase":
            let url = arguments as! String
            return GeodatabaseNativeObject(objectId: objectId, geodatabase: Geodatabase(fileURL: URL(string: url)!), messageSink: messageSink)
        case "RouteTask":
            let url = arguments as! String
            return RouteTaskNativeObject(objectId: objectId, task: RouteTask(url: URL(string: url)!), messageSink: messageSink)
        case "LocatorTask":
            let url = arguments as! String
            return LocatorTaskNativeObject(objectId: objectId, task: LocatorTask(url: URL(string: url)!), messageSink: messageSink)
        default:
            fatalError("Not implemented.")
        }
    }

    private func createOfflineMapTask(data: [String: Any]) -> OfflineMapTask {
        var offlineMapTask: OfflineMapTask
        if let map = data["map"] as? Dictionary<String, Any> {
            offlineMapTask = OfflineMapTask(onlineMap: Map(data: map))
        } else if let portalItem = data["portalItem"] as? Dictionary<String, Any> {
            offlineMapTask = OfflineMapTask(portalItem: PortalItem(data: portalItem))
        } else {
            fatalError("Invalid offline map task")
        }
        return offlineMapTask
    }
}
