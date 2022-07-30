package com.valentingrigorean.arcgis_maps_flutter.flutterobject;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

public abstract class BaseNativeHandler<T> implements NativeHandler {

    private final T nativeHandler;
    private boolean isDisposed = false;
    private NativeMessageSink messageSink;

    protected BaseNativeHandler(T nativeHandler) {
        this.nativeHandler = nativeHandler;
    }

    public T getNativeHandler() {
        return nativeHandler;
    }

    @Override
    public final void dispose() {
        if (isDisposed) {
            return;
        }
        isDisposed = true;
        disposeInternal();
    }

    @Override
    public void setMessageSink(@Nullable NativeMessageSink messageSink) {
        this.messageSink = messageSink;
    }

    protected boolean isDisposed() {
        return isDisposed;
    }

    protected void disposeInternal() {

    }

    protected void sendMessage(@NonNull String method, @Nullable Object args) {
        if (messageSink != null && !isDisposed) {
            messageSink.send(method, args);
        }
    }
}
