//
// Created by Valentin Grigorean on 26.07.2022.
//

import Foundation
import ArcGIS

extension TileCache {
    convenience init(data: Dictionary<String, Any>) {
        let url = data["url"] as! String
        self.init(fileURL: URL(fileURLWithPath: url))
    }

    static func createFlutter(data: Dictionary<String, Any>) -> TileCache {
        if let nativeObjectId = data["nativeObjectId"] as? String {
            let nativeObject = NativeObjectStorage.shared.getNativeObject(objectId: nativeObjectId) as? BaseNativeObject<TileCache>
            if let nativeObject = nativeObject {
                return nativeObject.nativeObject
            }
        }
        return TileCache(data: data)
    }
}