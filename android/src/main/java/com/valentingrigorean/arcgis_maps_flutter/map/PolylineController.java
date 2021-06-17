package com.valentingrigorean.arcgis_maps_flutter.map;

import android.graphics.Color;

import com.esri.arcgisruntime.mapping.view.Graphic;
import com.esri.arcgisruntime.symbology.SimpleLineSymbol;

public final class PolylineController extends BaseGraphicController {
    private final Graphic graphic;
    private final SimpleLineSymbol polylineSymbol;

    public PolylineController(String polylineId) {
        polylineSymbol = new SimpleLineSymbol(SimpleLineSymbol.Style.SOLID, Color.BLACK, 10);
        graphic = new Graphic();
        graphic.setSymbol(polylineSymbol);
        graphic.getAttributes().put("polylineId", polylineId);
    }

    @Override
    protected Graphic getGraphic() {
        return graphic;
    }

    public void setColor(int color) {
        polylineSymbol.setColor(color);
    }

    public void setWidth(float width) {
        polylineSymbol.setWidth(width);
    }

    public void setStyle(SimpleLineSymbol.Style style) {
        polylineSymbol.setStyle(style);
    }

    public void setAntialias(boolean antialias) {
        polylineSymbol.setAntiAlias(antialias);
    }

}
