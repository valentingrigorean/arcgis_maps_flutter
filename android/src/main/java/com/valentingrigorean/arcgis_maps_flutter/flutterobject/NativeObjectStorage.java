package com.valentingrigorean.arcgis_maps_flutter.flutterobject;

import androidx.annotation.NonNull;

import com.valentingrigorean.arcgis_maps_flutter.Convert;

import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

public class NativeObjectStorage {
    private static final NativeObjectStorage instance = new NativeObjectStorage();
    private HashMap<String, NativeObject> nativeObjects = new HashMap<>();

    private NativeObjectStorage() {

    }

    public static NativeObjectStorage getInstance() {
        return instance;
    }

    public void addNativeObject(@NonNull NativeObject object) {
        nativeObjects.putIfAbsent(object.getObjectId(), object);
    }

    public void removeNativeObject(@NonNull String objectId) {
        NativeObject object = nativeObjects.remove(objectId);
        if (object != null) {
            object.dispose();
        }
    }

    public NativeObject getNativeObject(@NonNull String objectId) {
        return nativeObjects.get(objectId);
    }

    public void clearAll() {
        nativeObjects.forEach((key, value) -> value.dispose());
        nativeObjects.clear();
    }


    public static <T> T getNativeObjectOrConvert(Object object, Function<Object, T> mappingFunction) {
        final Map<?, ?> data = Convert.toMap(object);
        final String objectId = (String) data.get("nativeObjectId");
        if (objectId != null) {
            final NativeObject nativeObject = NativeObjectStorage.getInstance().getNativeObject(objectId);
            if (nativeObject != null) {
                final BaseNativeObject<T> baseNativeObject = (BaseNativeObject<T>) nativeObject;
                return baseNativeObject.getNativeObject();
            }
        }
        return mappingFunction.apply(object);
    }
}
