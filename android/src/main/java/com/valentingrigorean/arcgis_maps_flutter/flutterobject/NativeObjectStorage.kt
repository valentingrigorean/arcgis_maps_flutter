package com.valentingrigorean.arcgis_maps_flutter.flutterobject

import com.valentingrigorean.arcgis_maps_flutter.Convert
import com.valentingrigorean.arcgis_maps_flutter.utils.toMap
import java.util.function.Function

class NativeObjectStorage private constructor() {
    private val nativeObjects = HashMap<String?, NativeObject>()
    fun addNativeObject(`object`: NativeObject) {
        nativeObjects.putIfAbsent(`object`.objectId, `object`)
    }

    fun removeNativeObject(objectId: String) {
        val `object` = nativeObjects.remove(objectId)
        `object`?.dispose()
    }

    fun<T : NativeObject> getNativeObject(objectId: String): T {
        return nativeObjects[objectId] as T
    }

    fun clearAll() {
        nativeObjects.forEach { (key: String?, value: NativeObject) -> value.dispose() }
        nativeObjects.clear()
    }

    companion object {
        val instance = NativeObjectStorage()
        fun <T> getNativeObjectOrConvert(`object`: Any?, mappingFunction: Function<Any?, T>): T? {
            val data: Map<*, *> = Convert.Companion.toMap(
                `object`!!
            )
            val objectId = data["nativeObjectId"] as String?
            if (objectId != null) {
                val nativeObject = instance.getNativeObject(objectId)
                if (nativeObject != null) {
                    val baseNativeObject = nativeObject as BaseNativeObject<T>
                    return baseNativeObject.nativeObject
                }
            }
            return mappingFunction.apply(`object`)
        }
    }
}