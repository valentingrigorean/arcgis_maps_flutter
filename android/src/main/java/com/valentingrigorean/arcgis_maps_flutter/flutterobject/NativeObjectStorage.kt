package com.valentingrigorean.arcgis_maps_flutter.flutterobject
import java.util.function.Function

class NativeObjectStorage private constructor() {
    private val nativeObjects = HashMap<String, NativeObject>()
    fun addNativeObject(nativeObject: NativeObject) {
        nativeObjects.putIfAbsent(nativeObject.objectId, nativeObject)
    }

    fun removeNativeObject(objectId: String) {
        val `object` = nativeObjects.remove(objectId)
        `object`?.dispose()
    }

    fun<T : NativeObject> getNativeObject(objectId: String): T {
        return nativeObjects[objectId] as T
    }

    fun clearAll() {
        nativeObjects.forEach { (_: String, value: NativeObject) -> value.dispose() }
        nativeObjects.clear()
    }

    companion object {
        val instance = NativeObjectStorage()
        fun <T> getNativeObjectOrConvert(obj: Any, mappingFunction: Function<Any?, T>): T? {
            val data = obj as Map<*, *>
            val objectId = data["nativeObjectId"] as String?
            if (objectId != null) {
                val nativeObject = instance.getNativeObject<NativeObject>(objectId)
                if (nativeObject != null) {
                    val baseNativeObject = nativeObject as BaseNativeObject<T>
                    return baseNativeObject.nativeObject
                }
            }
            return mappingFunction.apply(obj)
        }
    }
}