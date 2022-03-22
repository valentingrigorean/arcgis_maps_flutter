package com.valentingrigorean.arcgis_maps_flutter.map;

import com.esri.arcgisruntime.symbology.SimpleLineSymbol;

public interface PolygonControllerSink extends GraphicControllerSink {

    void setFillColor(int color);

    void setStrokeColor(int color);

    void setStrokeWidth(float width);

    void setStrokeStyle(SimpleLineSymbol.Style style);
}
