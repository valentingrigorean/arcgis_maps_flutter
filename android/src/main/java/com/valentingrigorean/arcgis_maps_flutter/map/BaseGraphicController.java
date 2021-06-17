package com.valentingrigorean.arcgis_maps_flutter.map;

import com.esri.arcgisruntime.geometry.Geometry;
import com.esri.arcgisruntime.mapping.view.Graphic;
import com.esri.arcgisruntime.mapping.view.GraphicsOverlay;

public abstract class BaseGraphicController {

    private boolean consumeTapEvents;

    protected abstract Graphic getGraphic();

    public void add(GraphicsOverlay graphicsOverlay) {
        graphicsOverlay.getGraphics().add(getGraphic());
    }

    public void remove(GraphicsOverlay graphicsOverlay) {
        graphicsOverlay.getGraphics().remove(getGraphic());
    }

    public void setVisible(boolean visible) {
        getGraphic().setVisible(visible);
    }

    public void setZIndex(int zIndex) {
        getGraphic().setZIndex(zIndex);
    }

    public void setGeometry(Geometry geometry) {
        getGraphic().setGeometry(geometry);
    }


    public void setSelected(boolean selected) {
        getGraphic().setSelected(selected);
    }

    public void setConsumeTapEvents(boolean consumeTapEvents) {
        this.consumeTapEvents = consumeTapEvents;
    }

    public boolean canConsumeTapEvents() {
        return consumeTapEvents;
    }
}
