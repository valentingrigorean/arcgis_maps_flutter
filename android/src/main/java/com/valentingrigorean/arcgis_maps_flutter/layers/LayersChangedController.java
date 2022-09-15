package com.valentingrigorean.arcgis_maps_flutter.layers;

import com.esri.arcgisruntime.layers.Layer;
import com.esri.arcgisruntime.mapping.ArcGISMap;
import com.esri.arcgisruntime.mapping.Basemap;
import com.esri.arcgisruntime.util.ListChangedEvent;
import com.esri.arcgisruntime.util.ListChangedListener;

import java.util.HashMap;

import io.flutter.plugin.common.MethodChannel;

public class LayersChangedController implements MapChangeAware, ArcGISMap.BasemapChangedListener {

    private final LayerChangeListener operationalLayersChanged;
    private final LayerChangeListener baseLayersChanged;
    private final LayerChangeListener referenceLayerChanged;

    private ArcGISMap map;

    private boolean isObserving = false;

    private boolean trackLayersChange = false;


    public LayersChangedController(MethodChannel channel) {
        operationalLayersChanged = new LayerChangeListener(channel, LayersController.LayerType.OPERATIONAL);
        baseLayersChanged = new LayerChangeListener(channel, LayersController.LayerType.BASE);
        referenceLayerChanged = new LayerChangeListener(channel, LayersController.LayerType.REFERENCE);
    }

    public void setTrackLayersChange(boolean val) {
        if (trackLayersChange == val) {
            return;
        }
        this.trackLayersChange = val;
        if (trackLayersChange) {
            addObservers();
        } else {
            removeObservers();
        }
    }

    @Override
    public void onMapChange(ArcGISMap map) {
        removeObservers();
        this.map = map;
        if (trackLayersChange) {
            addObservers();
        }
    }


    @Override
    public void basemapChanged(ArcGISMap.BasemapChangedEvent basemapChangedEvent) {

        if (basemapChangedEvent.getOldBasemap() != null) {
            final Basemap basemap = basemapChangedEvent.getOldBasemap();
            if (basemap != null) {
                basemap.getBaseLayers().removeListChangedListener(baseLayersChanged);
                basemap.getReferenceLayers().removeListChangedListener(referenceLayerChanged);
            }
        }
        if (isObserving) {
            final Basemap basemap = map.getBasemap();
            if (basemap != null) {
                basemap.getBaseLayers().addListChangedListener(baseLayersChanged);
                basemap.getReferenceLayers().addListChangedListener(referenceLayerChanged);
            }
        }
    }

    private void addObservers() {
        if (map == null) {
            return;
        }

        if (isObserving) {
            removeObservers();
        }
        map.getOperationalLayers().addListChangedListener(operationalLayersChanged);
        final Basemap basemap = map.getBasemap();
        if (basemap != null) {
            basemap.getBaseLayers().addListChangedListener(baseLayersChanged);
            basemap.getReferenceLayers().addListChangedListener(referenceLayerChanged);
        }

        isObserving = true;
    }

    private void removeObservers() {
        if (map == null) {
            return;
        }
        if (isObserving) {
            map.getOperationalLayers().removeListChangedListener(operationalLayersChanged);
            final Basemap basemap = map.getBasemap();
            if (basemap != null) {
                basemap.getBaseLayers().removeListChangedListener(baseLayersChanged);
                basemap.getReferenceLayers().removeListChangedListener(referenceLayerChanged);
            }
            isObserving = false;
        }
    }

    private class LayerChangeListener implements ListChangedListener<Layer> {

        private final MethodChannel channel;
        private final LayersController.LayerType layerType;

        private LayerChangeListener(MethodChannel channel,LayersController.LayerType layerType) {
            this.channel = channel;
            this.layerType = layerType;
        }

        @Override
        public void listChanged(ListChangedEvent<Layer> listChangedEvent) {
            final HashMap<String, Object> data = new HashMap<>(3);
            data.put("layerType", layerType.ordinal());
            data.put("layerChangeType", listChangedEvent.getAction() == ListChangedEvent.Action.ADDED ? 0 : 1);
            channel.invokeMethod("map#onLayersChanged", data);
        }

    }
}
