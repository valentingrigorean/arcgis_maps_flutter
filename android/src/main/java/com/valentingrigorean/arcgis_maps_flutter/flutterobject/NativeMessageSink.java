package com.valentingrigorean.arcgis_maps_flutter.flutterobject;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

public interface NativeMessageSink {
    void send(@NonNull String method, @Nullable Object args);
}
