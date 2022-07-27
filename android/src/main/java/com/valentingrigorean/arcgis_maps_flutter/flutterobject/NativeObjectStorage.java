package com.valentingrigorean.arcgis_maps_flutter.flutterobject;

import androidx.annotation.NonNull;

import java.util.HashMap;

public class NativeObjectStorage {
    private static final NativeObjectStorage instance = new NativeObjectStorage();
    private HashMap<String, ArcgisNativeObjectController> nativeObjects = new HashMap<>();

    private NativeObjectStorage() {

    }

    public static NativeObjectStorage getInstance() {
        return instance;
    }

    public void addNativeObject(@NonNull ArcgisNativeObjectController object) {
        nativeObjects.putIfAbsent(object.getObjectId(), object);
    }

    public void removeNativeObject(@NonNull String objectId) {
        ArcgisNativeObjectController object = nativeObjects.remove(objectId);
        if (object != null) {
            object.dispose();
        }
    }

    public ArcgisNativeObjectController getNativeObject(@NonNull String objectId) {
        return nativeObjects.get(objectId);
    }

    public void clearAll() {
        nativeObjects.forEach((key, value) -> value.dispose());
        nativeObjects.clear();
    }
}
