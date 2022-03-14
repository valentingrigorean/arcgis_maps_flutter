package com.valentingrigorean.arcgis_maps_flutter.map;

public interface MarkerControllerSink extends GraphicControllerSink {
    void setSelectedScale(float selectedScale);

    void setIcon(BitmapDescriptor bitmapDescriptor);

    void setBackground(BitmapDescriptor bitmapDescriptor);

    void setIconOffset(float offsetX,float offsetY);

    void setOpacity(float opacity);

    void setAngle(float angle);
}
