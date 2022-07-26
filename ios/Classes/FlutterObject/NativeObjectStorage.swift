//
// Created by Valentin Grigorean on 26.07.2022.
//

import Foundation

class NativeObjectStorage {
    private var nativeObjects: [String: ArcgisNativeObjectController] = [:]

    private init() {

    }

    static let shared = NativeObjectStorage()

    func getNativeObject(objectId: String) -> ArcgisNativeObjectController? {
        nativeObjects[objectId]
    }

    func removeNativeObject(objectId: String) -> ArcgisNativeObjectController? {
        nativeObjects.removeValue(forKey: objectId)
    }

    func addNativeObject(object: ArcgisNativeObjectController) {
        nativeObjects[object.objectId] = object
    }

    func clear() {
        for (objectId, nativeObject) in nativeObjects {
            nativeObject.dispose()
        }
        nativeObjects.removeAll()
    }
}