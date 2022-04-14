package com.valentingrigorean.arcgis_maps_flutter.map;

import com.esri.arcgisruntime.mapping.view.Graphic;
import com.esri.arcgisruntime.mapping.view.GraphicsOverlay;
import com.esri.arcgisruntime.mapping.view.LocationDisplay;
import com.esri.arcgisruntime.mapping.view.MapView;

public class LocationDisplayController implements MapTouchGraphicDelegate {
    private static final String LOCATION_ATTRIBUTE = "my_location_attribute";

    private final MapView mapView;
    private final LocationDisplay locationDisplay;
    private final GraphicsOverlay locationGraphicsOverlay;

    private final Graphic locationGraphic;

    private boolean trackUserLocationTap = false;

    public LocationDisplayController(MapView mapView, int mapId) {
        this.mapView = mapView;
        this.locationDisplay = mapView.getLocationDisplay();
        this.locationGraphicsOverlay = new GraphicsOverlay();
        this.locationGraphicsOverlay.setOpacity(0);
        this.locationGraphic = new Graphic();
        locationDisplay.getLocation().getAdditionalSourceProperties();
    }


    public void setTrackUserLocationTap(boolean trackUserLocationTap) {
        this.trackUserLocationTap = trackUserLocationTap;
    }


    @Override
    public boolean canConsumeTaps() {
        return trackUserLocationTap;
    }

    @Override
    public boolean didHandleGraphic(Graphic graphic) {
        return graphic.getAttributes().containsKey(LOCATION_ATTRIBUTE);
    }
}
