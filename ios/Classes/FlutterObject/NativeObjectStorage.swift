//
// Created by Valentin Grigorean on 26.07.2022.
//

import Foundation

class NativeObjectStorage {
    private var nativeObjects: [String: NativeObject] = [:]

    private init() {

    }

    static let shared = NativeObjectStorage()

    func addNativeObject(object: NativeObject) {
        nativeObjects[object.objectId] = object
    }

    func getNativeObject(objectId: String) -> NativeObject? {
        nativeObjects[objectId]
    }

    func removeNativeObject(objectId: String) -> Void {
        nativeObjects.removeValue(forKey: objectId)
    }

    func clearAll() {
        nativeObjects.removeAll()
    }
}
