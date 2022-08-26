package com.valentingrigorean.arcgis_maps_flutter.flutterobject;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.plugin.common.MethodChannel;

public interface NativeObject {
    String getObjectId();

    void dispose();

    void setMessageSink(@Nullable NativeMessageSink messageSink);

    void onMethodCall(@NonNull String method, @Nullable Object args, @NonNull MethodChannel.Result result);
}
