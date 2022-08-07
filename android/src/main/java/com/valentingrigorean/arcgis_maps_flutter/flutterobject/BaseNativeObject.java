package com.valentingrigorean.arcgis_maps_flutter.flutterobject;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.HashMap;

import io.flutter.plugin.common.MethodChannel;

public abstract class BaseNativeObject<T> implements NativeObject, NativeMessageSink {

    private final T nativeObject;
    private final String objectId;
    private final NativeHandler[] nativeHandlers;

    private ArcgisNativeObjectsController.NativeObjectControllerMessageSink messageSink;

    private boolean isDisposed = false;

    protected BaseNativeObject(String objectId, T nativeObject, NativeHandler[] nativeHandlers) {
        this.objectId = objectId;
        this.nativeObject = nativeObject;
        this.nativeHandlers = nativeHandlers;
        for (NativeHandler nativeHandler : nativeHandlers) {
            nativeHandler.setMessageSink(this);
        }
    }

    @Override
    protected void finalize() throws Throwable {
        dispose();
        super.finalize();
    }

    public T getNativeObject() {
        return nativeObject;
    }

    @Override
    public final void send(@NonNull String method, @Nullable Object args) {
        if (messageSink == null || isDisposed) {
            return;
        }
        final HashMap<String, Object> data = new HashMap<>(3);
        data.put("objectId", objectId);
        data.put("method", method);
        data.put("arguments", args);
        messageSink.send("messageNativeObject", data);
    }

    @Override
    public String getObjectId() {
        return objectId;
    }

    @Override
    public void setMessageSink(@Nullable ArcgisNativeObjectsController.NativeObjectControllerMessageSink messageSink) {
        this.messageSink = messageSink;
    }

    @Override
    public final void dispose() {
        if (isDisposed) {
            return;
        }
        isDisposed = true;
        disposeInternal();

        for (NativeHandler nativeHandler : nativeHandlers) {
            nativeHandler.setMessageSink(null);
            nativeHandler.dispose();
        }
    }

    @Override
    public void onMethodCall(@NonNull String method, @Nullable Object args, @NonNull MethodChannel.Result result) {
        for (NativeHandler nativeHandler : nativeHandlers) {
            if (nativeHandler.onMethodCall(method, args, result)) {
                return;
            }
        }
        result.notImplemented();
    }

    protected void disposeInternal() {

    }

    protected ArcgisNativeObjectsController.NativeObjectControllerMessageSink getMessageSink() {
        return messageSink;
    }

    protected final NativeObjectStorage getNativeObjectStorage() {
        return NativeObjectStorage.getInstance();
    }
}
