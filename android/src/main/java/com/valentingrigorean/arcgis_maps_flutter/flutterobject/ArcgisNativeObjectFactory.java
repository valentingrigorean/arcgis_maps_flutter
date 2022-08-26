package com.valentingrigorean.arcgis_maps_flutter.flutterobject;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

public interface ArcgisNativeObjectFactory {
    @NonNull
    NativeObject createNativeObject(@NonNull String objectId, @NonNull String type, @Nullable Object arguments, @NonNull NativeMessageSink messageSink);
}
