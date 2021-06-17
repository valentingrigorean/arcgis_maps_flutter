package com.valentingrigorean.arcgis_maps_flutter.map;

import com.esri.arcgisruntime.mapping.view.Graphic;

public interface MapTouchGraphicDelegate {
    boolean canConsumeTaps();

    boolean didHandleGraphic(Graphic graphic);
}
