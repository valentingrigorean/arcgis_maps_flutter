package com.valentingrigorean.arcgis_maps_flutter.map;

import android.graphics.Color;

import com.esri.arcgisruntime.geometry.Geometry;
import com.esri.arcgisruntime.mapping.view.GraphicsOverlay;

public interface GraphicControllerSink {
    void add(GraphicsOverlay graphicsOverlay);

    void remove(GraphicsOverlay graphicsOverlay);

    boolean getVisible();

    void setVisible(boolean visible);

    void setZIndex(int zIndex);

    void setGeometry(Geometry geometry);

    boolean isSelected();

    void setSelected(boolean selected);

    boolean canConsumeTapEvents();

    void setConsumeTapEvents(boolean consumeTapEvent);

    void setSelectedColor(Color color);
}
