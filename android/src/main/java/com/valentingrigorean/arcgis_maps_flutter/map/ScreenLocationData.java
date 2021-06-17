package com.valentingrigorean.arcgis_maps_flutter.map;

import android.graphics.Point;

import com.esri.arcgisruntime.geometry.SpatialReference;


public class ScreenLocationData {
    private final Point point;
    private final SpatialReference spatialReference;


    public ScreenLocationData(Point point, SpatialReference spatialReference) {
        this.point = point;
        this.spatialReference = spatialReference;
    }

    public Point getPoint() {
        return point;
    }

    public SpatialReference getSpatialReference() {
        return spatialReference;
    }
}
