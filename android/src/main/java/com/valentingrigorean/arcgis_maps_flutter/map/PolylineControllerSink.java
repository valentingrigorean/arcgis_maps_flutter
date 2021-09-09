package com.valentingrigorean.arcgis_maps_flutter.map;

import com.esri.arcgisruntime.symbology.SimpleLineSymbol;

public interface PolylineControllerSink extends GraphicControllerSink {
    void setColor(int color);

    void setWidth(float width);

    void setStyle(SimpleLineSymbol.Style style);

    void setAntialias(boolean antialias);
}
