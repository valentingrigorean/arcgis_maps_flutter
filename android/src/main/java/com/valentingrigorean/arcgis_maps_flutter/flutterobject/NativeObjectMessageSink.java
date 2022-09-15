package com.valentingrigorean.arcgis_maps_flutter.flutterobject;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.HashMap;

public class NativeObjectMessageSink implements NativeMessageSink {
    private final String objectId;
    private final NativeMessageSink messageSink;
    private final HashMap<String, Object> data = new HashMap<>(3);


    public NativeObjectMessageSink(String objectId, NativeMessageSink messageSink) {
        this.objectId = objectId;
        this.messageSink = messageSink;
    }

    @Override
    public void send(@NonNull String method, @Nullable Object args) {
        data.clear();
        data.put("objectId", objectId);
        data.put("method", method);
        data.put("arguments", args);
        messageSink.send("messageNativeObject", data);
    }
}
