package com.valentingrigorean.arcgis_maps_flutter.map;

import android.content.Context;

import com.esri.arcgisruntime.mapping.view.Graphic;
import com.esri.arcgisruntime.symbology.CompositeSymbol;
import com.esri.arcgisruntime.symbology.PictureMarkerSymbol;
import com.esri.arcgisruntime.symbology.Symbol;

public final class MarkerController extends BaseGraphicController {
    private final CompositeSymbol marker = new CompositeSymbol();
    private final Graphic graphic;

    private BitmapDescriptor icon;
    private Symbol iconSymbol;
    private BitmapDescriptor background;
    private Symbol backgroundSymbol;

    private float opacity = 1;

    private float iconOffsetX = 0;
    private float iconOffsetY = 0;
    private Context context;

    public MarkerController(Context context, String markerId,SelectionPropertiesHandler selectionPropertiesHandler) {
        super(selectionPropertiesHandler);
        this.context = context;
        graphic = new Graphic();
        graphic.setSymbol(marker);
        graphic.getAttributes().put("markerId", markerId);
    }

    @Override
    protected Graphic getGraphic() {
        return graphic;
    }

    public Context getContext() {
        return context;
    }


    public void setIcon(BitmapDescriptor bitmapDescriptor) {
        if (bitmapDescriptor == icon) {
            return;
        }

        if (iconSymbol != null) {
            marker.getSymbols().remove(iconSymbol);
        }
        icon = bitmapDescriptor;
        bitmapDescriptor.createSymbolAsync(new BitmapDescriptor.BitmapDescriptorListener() {
            @Override
            public void onLoaded(Symbol symbol) {
                iconSymbol = symbol;
                setOpacity(iconSymbol, opacity);
                offsetSymbol(symbol, iconOffsetX, iconOffsetY);
                marker.getSymbols().add(symbol);
            }

            @Override
            public void onFailed() {

            }
        });
    }

    public void setBackground(BitmapDescriptor bitmapDescriptor) {
        if (bitmapDescriptor == background) {
            return;
        }
        if (backgroundSymbol != null) {
            marker.getSymbols().remove(backgroundSymbol);
        }

        background = bitmapDescriptor;
        bitmapDescriptor.createSymbolAsync(new BitmapDescriptor.BitmapDescriptorListener() {
            @Override
            public void onLoaded(Symbol symbol) {
                backgroundSymbol = symbol;
                setOpacity(backgroundSymbol, opacity);
                marker.getSymbols().add(0, symbol);
            }

            @Override
            public void onFailed() {

            }
        });
    }

    public void setIconOffset(float offsetX, float offsetY) {
        if (offsetX == iconOffsetX && offsetY == iconOffsetY) {
            return;
        }
        iconOffsetX = offsetX;
        iconOffsetY = offsetY;
        if (iconSymbol != null) {
            offsetSymbol(iconSymbol, offsetX, offsetY);
        }
    }

    public void setOpacity(float opacity) {
        this.opacity = opacity;
        for (final Symbol symbol : marker.getSymbols()) {
            setOpacity(symbol, opacity);
        }
    }


    private static void offsetSymbol(Symbol symbol, float offsetX, float offsetY) {
        if (symbol instanceof PictureMarkerSymbol) {
            ((PictureMarkerSymbol) symbol).setOffsetX(offsetX);
            ((PictureMarkerSymbol) symbol).setOffsetY(offsetY);
        }
    }

    private static void setOpacity(Symbol symbol, float opacity) {
        if (symbol instanceof PictureMarkerSymbol) {
            ((PictureMarkerSymbol) symbol).setOpacity(opacity);
        }
    }

    private static void setSymbolSize(Symbol symbol, float width, float height) {
        if (symbol instanceof PictureMarkerSymbol) {
            ((PictureMarkerSymbol) symbol).setWidth(width);
            ((PictureMarkerSymbol) symbol).setHeight(height);
        }
    }
}
