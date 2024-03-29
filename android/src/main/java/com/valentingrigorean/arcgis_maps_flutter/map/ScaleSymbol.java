package com.valentingrigorean.arcgis_maps_flutter.map;

import com.esri.arcgisruntime.symbology.CompositeSymbol;
import com.esri.arcgisruntime.symbology.PictureFillSymbol;
import com.esri.arcgisruntime.symbology.PictureMarkerSymbol;
import com.esri.arcgisruntime.symbology.Symbol;

import java.util.ArrayList;

public class ScaleSymbol extends Symbol {
    private final Symbol symbol;
    private final ArrayList<SymbolScaleHandle> scaleHandles = new ArrayList<>();

    public ScaleSymbol(Symbol symbol) {
        super(symbol.getInternal());
        this.symbol = symbol;
        populateDefaultSize(symbol);
    }


    public Symbol getSymbol() {
        return symbol;
    }

    public void setScale(float scale) {
        for (final SymbolScaleHandle scaleHandle : scaleHandles) {
            scaleHandle.setScale(scale);
        }
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize();
        scaleHandles.clear();
    }

    private void populateDefaultSize(Symbol symbol) {
        if (symbol instanceof CompositeSymbol) {
            CompositeSymbol compositeSymbol = (CompositeSymbol) symbol;
            if (compositeSymbol != null) {
                for (final Symbol child : compositeSymbol.getSymbols()) {
                    populateDefaultSize(child);
                }
            }
        } else {
            scaleHandles.add(new SymbolScaleHandle(symbol));
        }
    }

    private class SymbolScaleHandle {
        private final float width;
        private final float height;
        private final boolean haveSize;
        private final Symbol symbol;

        private float scale = 1f;

        public SymbolScaleHandle(Symbol symbol) {
            this.symbol = symbol;
            if (symbol instanceof PictureMarkerSymbol) {
                PictureMarkerSymbol pictureMarkerSymbol = (PictureMarkerSymbol) symbol;
                haveSize = true;
                width = pictureMarkerSymbol.getWidth();
                height = pictureMarkerSymbol.getHeight();
            } else if (symbol instanceof PictureFillSymbol) {
                PictureFillSymbol pictureFillSymbol = (PictureFillSymbol) symbol;
                haveSize = true;
                width = pictureFillSymbol.getWidth();
                height = pictureFillSymbol.getHeight();
            } else {
                haveSize = false;
                width = 0;
                height = 0;
            }
        }

        public void setScale(float scale) {
            if (!haveSize) {
                return;
            }
            if (this.scale == scale) {
                return;
            }
            this.scale = scale;
            final float newWidth = width * scale;
            final float newHeight = height * scale;
            if (symbol instanceof PictureMarkerSymbol) {
                PictureMarkerSymbol pictureMarkerSymbol = (PictureMarkerSymbol) symbol;
                pictureMarkerSymbol.setWidth(newWidth);
                pictureMarkerSymbol.setHeight(newHeight);
            } else if (symbol instanceof PictureFillSymbol) {
                PictureFillSymbol pictureFillSymbol = (PictureFillSymbol) symbol;
                pictureFillSymbol.setWidth(newWidth);
                pictureFillSymbol.setHeight(newHeight);
            }
        }
    }
}
