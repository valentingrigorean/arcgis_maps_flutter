//
// Created by Valentin Grigorean on 26.07.2022.
//

import Foundation
import ArcGIS

extension AGSTileCache {
    convenience init(data: Dictionary<String, Any>) {
        let url = data["url"] as! String
        self.init(name: url)
    }

    static func createFlutter(data: Dictionary<String, Any>) -> AGSTileCache {
        if let nativeObjectId = data["nativeObjectId"] as? String {
            let nativeObject = NativeObjectStorage.shared.getNativeObject(objectId: nativeObjectId) as? TileCacheNativeObject
            if let nativeObject = nativeObject {
                return nativeObject.tileCache
            }
        }
        return AGSTileCache(data: data)
    }
}