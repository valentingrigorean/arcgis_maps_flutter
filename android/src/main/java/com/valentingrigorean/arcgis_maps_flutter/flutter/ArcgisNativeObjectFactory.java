package com.valentingrigorean.arcgis_maps_flutter.flutter;

import androidx.annotation.NonNull;

import java.util.Map;

public interface ArcgisNativeObjectFactory {
    @NonNull
    ArcgisNativeObjectController createNativeObject(Map<?,?> args,NativeMessageSink nativeMessageSink);
}
