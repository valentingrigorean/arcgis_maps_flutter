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
    private ScaleSymbol iconSymbol;
    private BitmapDescriptor background;
    private ScaleSymbol backgroundSymbol;

    private float opacity = 1;

    private float iconOffsetX = 0;
    private float iconOffsetY = 0;
    private Context context;

    private boolean isSelected;

    private float selectedScale = 1.4f;


    public MarkerController(Context context, String markerId, SelectionPropertiesHandler selectionPropertiesHandler) {
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

    public void setSelectedScale(float selectedScale) {
        this.selectedScale = selectedScale;
        handleScaleChange();
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
                iconSymbol = new ScaleSymbol(symbol);
                setOpacity(iconSymbol, opacity);
                offsetSymbol(symbol, iconOffsetX, iconOffsetY);
                marker.getSymbols().add(iconSymbol);
                handleScaleChange();
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
                backgroundSymbol = new ScaleSymbol(symbol);

                setOpacity(backgroundSymbol, opacity);
                marker.getSymbols().add(0, backgroundSymbol);
                handleScaleChange();
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

    @Override
    public void setSelected(boolean selected) {
        if (selected == isSelected)
            return;
        isSelected = selected;
        handleScaleChange();
    }

    private void handleScaleChange() {
        final float scale = isSelected ? selectedScale : 1f;
        if (backgroundSymbol != null) {
            backgroundSymbol.setScale(scale);
        }
        if (iconSymbol != null) {
            iconSymbol.setScale(scale);
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
}
