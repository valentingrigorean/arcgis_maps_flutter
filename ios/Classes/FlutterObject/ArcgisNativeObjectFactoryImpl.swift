//
// Created by Valentin Grigorean on 25.07.2022.
//

import Foundation

class ArcgisNativeObjectFactoryImpl: ArcgisNativeObjectFactory {
    func createNativeObject(objectId: String, type: String, arguments: Any?, messageSink: NativeMessageSink) -> ArcgisNativeObjectController {
        switch (type) {
        case "ExportTileCacheTask":
            let url = arguments as! String
            return ExportTileCacheTaskNativeObject(objectId: objectId, url: url, messageSink: messageSink)
        case "AGSExportTileCacheParameters":

        default:
            fatalError("Not implemented.")
        }
    }
}