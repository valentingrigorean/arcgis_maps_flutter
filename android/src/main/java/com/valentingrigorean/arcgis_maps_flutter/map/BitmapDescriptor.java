package com.valentingrigorean.arcgis_maps_flutter.map;


import com.esri.arcgisruntime.symbology.Symbol;

public interface BitmapDescriptor {


    interface BitmapDescriptorListener {
        void onLoaded(Symbol symbol);

        void onFailed();
    }

    void createSymbolAsync(BitmapDescriptorListener loader);
}
