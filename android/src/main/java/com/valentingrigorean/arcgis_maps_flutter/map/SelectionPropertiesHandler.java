package com.valentingrigorean.arcgis_maps_flutter.map;

import android.graphics.Color;

import com.esri.arcgisruntime.mapping.SelectionProperties;
import com.esri.arcgisruntime.mapping.view.Graphic;

public class SelectionPropertiesHandler {
    private final SelectionProperties selectionProperties;
    private final int defaultSelectedColor;

    public SelectionPropertiesHandler(SelectionProperties selectionProperties) {
        this.selectionProperties = selectionProperties;
        this.defaultSelectedColor = selectionProperties.getColor();
    }

    public void setSelected(Graphic graphic, Color selectedColor) {
        if (selectedColor != null) {
            selectionProperties.setColor(selectedColor.toArgb());
        } else {
            reset();
        }
        graphic.setSelected(true);
    }

    public void clearSelection(Graphic graphic) {
        graphic.setSelected(false);
        reset();
    }

    public void reset() {
        if (selectionProperties.getColor() == defaultSelectedColor)
            return;
        selectionProperties.setColor(defaultSelectedColor);
    }
}
