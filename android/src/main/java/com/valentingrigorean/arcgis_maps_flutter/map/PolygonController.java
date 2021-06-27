package com.valentingrigorean.arcgis_maps_flutter.map;

import android.graphics.Color;

import com.esri.arcgisruntime.mapping.view.Graphic;
import com.esri.arcgisruntime.symbology.SimpleFillSymbol;
import com.esri.arcgisruntime.symbology.SimpleLineSymbol;

public final class PolygonController extends BaseGraphicController {

    private final Graphic graphic;
    private final SimpleFillSymbol polygonSymbol;
    private final SimpleLineSymbol polygonStrokeSymbol;

    public PolygonController(String polygonId,SelectionPropertiesHandler selectionPropertiesHandler) {
        super(selectionPropertiesHandler);
        polygonStrokeSymbol = new SimpleLineSymbol(SimpleLineSymbol.Style.SOLID, Color.BLACK, 10);
        polygonSymbol = new SimpleFillSymbol(SimpleFillSymbol.Style.SOLID, Color.BLACK, polygonStrokeSymbol);

        graphic = new Graphic();
        graphic.setSymbol(polygonSymbol);
        graphic.getAttributes().put("polygonId", polygonId);
    }

    public void setFillColor(int color) {
        polygonSymbol.setColor(color);
    }

    public void setStrokeColor(int color) {
        polygonStrokeSymbol.setColor(color);
    }

    public void setStrokeWidth(float width) {
        polygonStrokeSymbol.setWidth(width);
    }

    @Override
    protected Graphic getGraphic() {
        return graphic;
    }
}
