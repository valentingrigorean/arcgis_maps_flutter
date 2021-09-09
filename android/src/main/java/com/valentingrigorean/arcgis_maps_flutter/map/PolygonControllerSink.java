package com.valentingrigorean.arcgis_maps_flutter.map;

public interface PolygonControllerSink extends GraphicControllerSink {

    void setFillColor(int color);

    void setStrokeColor(int color);

    void setStrokeWidth(float width);
}
