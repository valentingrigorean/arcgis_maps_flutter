package com.valentingrigorean.arcgis_maps_flutter.flutter;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

public interface ArcgisNativeObjectFactory {
    @NonNull
    ArcgisNativeObjectController createNativeObject(@NonNull String objectId, @NonNull String type, @Nullable Object arguments, @NonNull NativeMessageSink nativeMessageSink);
}
