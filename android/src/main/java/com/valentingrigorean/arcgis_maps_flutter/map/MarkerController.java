package com.valentingrigorean.arcgis_maps_flutter.map;

import android.content.Context;

import com.esri.arcgisruntime.mapping.view.Graphic;
import com.esri.arcgisruntime.symbology.CompositeSymbol;
import com.esri.arcgisruntime.symbology.MarkerSymbol;
import com.esri.arcgisruntime.symbology.PictureMarkerSymbol;
import com.esri.arcgisruntime.symbology.Symbol;

public final class MarkerController extends BaseGraphicController implements MarkerControllerSink {
    private final CompositeSymbol marker = new CompositeSymbol();
    private final Graphic graphic;

    private BitmapDescriptor icon;
    private ScaleSymbol iconSymbol;
    private BitmapDescriptor background;
    private ScaleSymbol backgroundSymbol;

    private float opacity = 1;

    private float angle = 0.0f;

    private float iconOffsetX = 0;
    private float iconOffsetY = 0;
    private Context context;

    private boolean isSelected;

    private float selectedScale = 1.4f;


    public MarkerController(Context context, String markerId) {
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
                setAngle(iconSymbol, angle);
                offsetSymbol(iconSymbol, iconOffsetX, iconOffsetY);
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
                setAngle(backgroundSymbol, angle);
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
            offsetSymbol(iconSymbol.getSymbol(), offsetX, offsetY);
        }
    }

    public void setOpacity(float opacity) {
        if (this.opacity == opacity) {
            return;
        }
        this.opacity = opacity;
        for (final Symbol symbol : marker.getSymbols()) {
            setOpacity(symbol, opacity);
        }
    }

    public void setAngle(float angle) {
        if (this.angle == angle) {
            return;
        }
        this.angle = angle;
        for (final Symbol symbol : marker.getSymbols()) {
            setAngle(symbol, angle);
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
            final PictureMarkerSymbol pictureMarkerSymbol = (PictureMarkerSymbol) symbol;
            pictureMarkerSymbol.setOffsetX(offsetX);
            pictureMarkerSymbol.setOffsetY(offsetY);
        }
        if (symbol instanceof ScaleSymbol) {
            final ScaleSymbol scaleSymbol = (ScaleSymbol) symbol;
            offsetSymbol(scaleSymbol.getSymbol(), offsetX, offsetY);
        }
    }

    private static void setOpacity(Symbol symbol, float opacity) {
        if (symbol instanceof PictureMarkerSymbol) {
            ((PictureMarkerSymbol) symbol).setOpacity(opacity);
        }
        if (symbol instanceof ScaleSymbol) {
            final ScaleSymbol scaleSymbol = (ScaleSymbol) symbol;
            setOpacity(scaleSymbol.getSymbol(), opacity);
        }
    }

    private static void setAngle(Symbol symbol, float angle) {
        if (symbol instanceof MarkerSymbol) {
            ((MarkerSymbol) symbol).setAngle(angle);
            ((MarkerSymbol) symbol).setAngleAlignment(Float.compare(angle, 0) == 0 ? MarkerSymbol.AngleAlignment.SCREEN : MarkerSymbol.AngleAlignment.MAP);
        }
        if (symbol instanceof ScaleSymbol) {
            final ScaleSymbol scaleSymbol = (ScaleSymbol) symbol;
            setAngle(scaleSymbol.getSymbol(), angle);
        }
    }
}
