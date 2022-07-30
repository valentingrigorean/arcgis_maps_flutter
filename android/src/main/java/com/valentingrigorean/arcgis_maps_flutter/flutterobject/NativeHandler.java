package com.valentingrigorean.arcgis_maps_flutter.flutterobject;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.plugin.common.MethodChannel;

public interface NativeHandler {
    void dispose();

    void setMessageSink(@Nullable NativeMessageSink messageSink);

    boolean onMethodCall(@NonNull String method, @Nullable Object args, @NonNull MethodChannel.Result result);
}
