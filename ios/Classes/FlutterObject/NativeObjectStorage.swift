//
// Created by Valentin Grigorean on 26.07.2022.
//

import Foundation

class NativeObjectStorage {
    private var nativeObjects: [String: ArcgisNativeObjectController] = [:]

    private init() {

    }

    static let shared = NativeObjectStorage()

    func addNativeObject(object: ArcgisNativeObjectController) {
        nativeObjects[object.objectId] = object
    }

    func getNativeObject(objectId: String) -> ArcgisNativeObjectController? {
        nativeObjects[objectId]
    }

    func removeNativeObject(objectId: String) -> Void {
        let object = nativeObjects.removeValue(forKey: objectId)
        object?.dispose()
    }

    func clearAll() {
        for (_, nativeObject) in nativeObjects {
            nativeObject.dispose()
        }
        nativeObjects.removeAll()
    }
}
