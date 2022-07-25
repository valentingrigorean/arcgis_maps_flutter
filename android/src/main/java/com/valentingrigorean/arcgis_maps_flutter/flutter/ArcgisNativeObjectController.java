package com.valentingrigorean.arcgis_maps_flutter.flutter;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.HashMap;
import java.util.List;

import io.flutter.plugin.common.MethodChannel;

public abstract class ArcgisNativeObjectController implements NativeMessageSink {
    private final List<NativeHandler> nativeHandlers;
    private NativeMessageSink messageSink;
    private final int objectId;
    private boolean disposed = false;

    protected ArcgisNativeObjectController(int objectId, List<NativeHandler> nativeHandlers) {
        this.objectId = objectId;
        this.nativeHandlers = nativeHandlers;
    }

    public interface NativeHandler {
        void dispose();

        void setMessageSink(@Nullable NativeMessageSink messageSink);

        boolean onMethodCall(@NonNull String method, @Nullable Object args, @NonNull MethodChannel.Result result);
    }

    public void dispose() {
        if (disposed) {
            return;
        }
        disposed = true;
        for (NativeHandler nativeHandler : nativeHandlers) {
            nativeHandler.dispose();
        }
    }

    public void setMessageSink(@Nullable NativeMessageSink messageSink) {
        this.messageSink = messageSink;
        for (NativeHandler nativeHandler : nativeHandlers) {
            nativeHandler.setMessageSink(this);
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
}
