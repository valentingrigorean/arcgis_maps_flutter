package com.valentingrigorean.arcgis_maps_flutter;

import androidx.annotation.Nullable;
import androidx.lifecycle.Lifecycle;

public interface LifecycleProvider {

    @Nullable
    Lifecycle getLifecycle();
}