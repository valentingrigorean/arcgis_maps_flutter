package com.valentingrigorean.arcgis_maps_flutter.map;

import android.graphics.Color;

import com.esri.arcgisruntime.geometry.Geometry;
import com.esri.arcgisruntime.mapping.view.Graphic;
import com.esri.arcgisruntime.mapping.view.GraphicsOverlay;

public abstract class BaseGraphicController implements GraphicControllerSink {

    private SelectionPropertiesHandler selectionPropertiesHandler;
    private boolean consumeTapEvents;
    private Color selectedColor;


    protected abstract Graphic getGraphic();

    public void setSelectionPropertiesHandler(SelectionPropertiesHandler selectionPropertiesHandler) {
        this.selectionPropertiesHandler = selectionPropertiesHandler;
    }

    public void add(GraphicsOverlay graphicsOverlay) {
        graphicsOverlay.getGraphics().add(getGraphic());
    }

    public void remove(GraphicsOverlay graphicsOverlay) {
        graphicsOverlay.getGraphics().remove(getGraphic());
    }

    public boolean getVisible() {
        return getGraphic().isVisible();
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

    public boolean isSelected() {
        return getGraphic().isSelected();
    }

    public void setSelected(boolean selected) {
        final Graphic graphic = getGraphic();
        if (selected && !graphic.isSelected()) {
            selectionPropertiesHandler.setSelected(graphic, selectedColor);
        } else if (graphic.isSelected()) {
            selectionPropertiesHandler.clearSelection(graphic);
        }
    }

    public void setConsumeTapEvents(boolean consumeTapEvents) {
        this.consumeTapEvents = consumeTapEvents;
    }

    public boolean canConsumeTapEvents() {
        return consumeTapEvents;
    }


    public void setConsumeTapEvent(boolean consumeTapEvent) {
        this.consumeTapEvents = consumeTapEvent;
    }

    public void setSelectedColor(Color selectedColor) {
        this.selectedColor = selectedColor;
    }
}
