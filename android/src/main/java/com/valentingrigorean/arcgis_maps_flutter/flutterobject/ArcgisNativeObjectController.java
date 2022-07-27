package com.valentingrigorean.arcgis_maps_flutter.flutterobject;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.HashMap;
import java.util.List;

import io.flutter.plugin.common.MethodChannel;

public abstract class ArcgisNativeObjectController implements NativeMessageSink {
    private final NativeHandler[] nativeHandlers;
    private final ArcgisNativeObjectsController.NativeObjectControllerMessageSink messageSink;
    private final String objectId;
    private boolean disposed = false;

    protected ArcgisNativeObjectController(String objectId, NativeHandler[] nativeHandlers, ArcgisNativeObjectsController.NativeObjectControllerMessageSink messageSink) {
        this.objectId = objectId;
        this.nativeHandlers = nativeHandlers;
        this.messageSink = messageSink;
        for (NativeHandler nativeHandler : nativeHandlers) {
            nativeHandler.setMessageSink(this);
        }
    }

    public interface NativeHandler {
        void dispose();

        void setMessageSink(@Nullable NativeMessageSink messageSink);

        boolean onMethodCall(@NonNull String method, @Nullable Object args, @NonNull MethodChannel.Result result);
    }

    public String getObjectId() {
        return objectId;
    }

    public void dispose() {
        if (disposed) {
            return;
        }
        disposed = true;
        for (NativeHandler nativeHandler : nativeHandlers) {
            nativeHandler.setMessageSink(null);
            nativeHandler.dispose();
        }
    }

    public void onMethodCall(@NonNull String method, @Nullable Object args, @NonNull MethodChannel.Result result) {
        for (NativeHandler nativeHandler : nativeHandlers) {
            if (nativeHandler.onMethodCall(method, args, result)) {
                return;
            }
        }
        result.notImplemented();
    }

    public final void send(@NonNull String method, @Nullable Object args) {
        final HashMap<String, Object> data = new HashMap<>(3);
        data.put("objectId", objectId);
        data.put("method", method);
        data.put("arguments", args);
        messageSink.send("messageNativeObject", data);
    }

    protected final NativeObjectStorage getNativeObjectStorage() {
        return NativeObjectStorage.getInstance();
    }

    protected final ArcgisNativeObjectsController.NativeObjectControllerMessageSink getMessageSink() {
        return messageSink;
    }
}
