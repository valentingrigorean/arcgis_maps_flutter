package com.valentingrigorean.arcgis_maps_flutter.layers;

import androidx.annotation.Nullable;

import com.esri.arcgisruntime.mapping.ArcGISMap;

public interface MapChangeAware {
    void onMapChange(@Nullable ArcGISMap map);
}
