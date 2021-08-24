package com.valentingrigorean.arcgis_maps_flutter.map;

import com.esri.arcgisruntime.layers.Layer;
import com.esri.arcgisruntime.mapping.ArcGISMap;
import com.valentingrigorean.arcgis_maps_flutter.utils.StringUtils;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

import io.flutter.plugin.common.MethodChannel;


class LayersController {

    private enum LayerType {
        OPERATIONAL,
        BASE,
        REFERENCE
    }

    private final Set<FlutterLayer> operationalLayers = new HashSet<>();
    private final Set<FlutterLayer> baseLayers = new HashSet<>();
    private final Set<FlutterLayer> referenceLayers = new HashSet<>();

    private final Map<String, Layer> flutterOperationalLayersMap = new HashMap<>();
    private final Map<String, Layer> flutterBaseLayersMap = new HashMap<>();
    private final Map<String, Layer> flutterReferenceLayersMap = new HashMap<>();

    private final MethodChannel methodChannel;

    private ArcGISMap map;

    public LayersController(MethodChannel methodChannel) {
        this.methodChannel = methodChannel;
    }

    public void setMap(ArcGISMap map) {
        clearMap();
        this.map = map;

        addLayersToMap(operationalLayers, LayerType.OPERATIONAL);
        addLayersToMap(baseLayers, LayerType.BASE);
        addLayersToMap(referenceLayers, LayerType.REFERENCE);
    }

    public Layer getLayerByLayerId(String id) {
        if (flutterOperationalLayersMap.containsKey(id)) {
            return flutterOperationalLayersMap.get(id);
        }
        if (flutterBaseLayersMap.containsKey(id)) {
            return flutterBaseLayersMap.get(id);
        }
        if (flutterReferenceLayersMap.containsKey(id)) {
            return flutterReferenceLayersMap.get(id);
        }
        return null;
    }

    public void updateFromArgs(Object args) {
        final Map<?, ?> mapData = (Map<?, ?>) args;
        if (mapData == null || mapData.size() == 0) {
            return;
        }

        for (LayerType layerType : LayerType.values()) {
            String objectName = getObjectName(layerType);
            Object layersToAdd = mapData.get(objectName + "sToAdd");
            if (layersToAdd != null) {
                addLayers(layersToAdd, layerType);
            }

            Object layersToUpdate = mapData.get(objectName + "sToChange");
            if (layersToUpdate != null) {
                removeLayers(layersToUpdate, layerType);
                addLayers(layersToUpdate, layerType);
            }

            Object layersToRemove = mapData.get(objectName + "IdsToRemove");
            if (layersToRemove != null) {
                removeLayersById((Collection<String>) layersToRemove, layerType);
            }
        }
    }

    private void addLayers(Object args, LayerType layerType) {

        final Collection<Map<?, ?>> layersArgs = (Collection<Map<?, ?>>) args;
        if (layersArgs == null || layersArgs.size() == 0) {
            return;
        }


        final Map<String, Layer> flutterMap = getFlutterMap(layerType);
        final Set<FlutterLayer> flutterLayers = getFlutterLayerSet(layerType);

        final ArrayList<FlutterLayer> layersToAdd = new ArrayList<>();

        for (Map<?, ?> layer : layersArgs) {
            final String layerId = (String) layer.get("layerId");
            if (flutterMap.containsKey(layerId)) {
                continue;
            }
            final FlutterLayer flutterLayer = new FlutterLayer(layer);
            layersToAdd.add(flutterLayer);
            flutterLayers.add(flutterLayer);
        }

        addLayersToMap(layersToAdd, layerType);
    }

    private void removeLayers(Object args, LayerType layerType) {
        final Collection<Map<?, ?>> layersArgs = (Collection<Map<?, ?>>) args;
        if (layersArgs == null || layersArgs.size() == 0) {
            return;
        }
        final Map<String, Layer> flutterMap = getFlutterMap(layerType);
        final ArrayList<FlutterLayer> layersToRemove = new ArrayList<>();

        for (Map<?, ?> layer : layersArgs) {
            final String layerId = (String) layer.get("layerId");
            if (layerId == null || !flutterMap.containsKey(layerId)) {
                continue;
            }
            final FlutterLayer flutterLayer = new FlutterLayer(layer);
            layersToRemove.add(flutterLayer);
        }

        removeLayersFromMap(layersToRemove, layerType);
    }

    private void removeLayersById(Collection<String> ids, LayerType layerType) {
        if (ids.size() == 0)
            return;
        final ArrayList<FlutterLayer> layersToRemove = new ArrayList<>();
        final Set<FlutterLayer> layers = getFlutterLayerSet(layerType);
        for (String id : ids) {
            final Optional<FlutterLayer> flutterLayer = layers.stream().filter(e -> StringUtils.areEqual(e.getLayerId(), id)).findFirst();
            if (flutterLayer.isPresent()) {
                layersToRemove.add(flutterLayer.get());
            }
        }

        removeLayersFromMap(layersToRemove, layerType);
    }

    private void addLayersToMap(Collection<FlutterLayer> layers, LayerType layerType) {
        if (layers.size() == 0)
            return;
        if (map == null) {
            return;
        }

        final Map<String, Layer> flutterMap = getFlutterMap(layerType);

        for (FlutterLayer layer : layers) {
            final Layer nativeLayer = layer.createLayer();
            flutterMap.put(layer.getLayerId(), nativeLayer);
            nativeLayer.addDoneLoadingListener(() -> {
                if (flutterMap.containsKey(layer.getLayerId())) {
                    final Map<String, Object> args = new HashMap<>(1);
                    args.put("layerId", layer.getLayerId());
                    methodChannel.invokeMethod("layer#loaded", args);
                }
            });
            switch (layerType) {
                case OPERATIONAL:
                    map.getOperationalLayers().add(nativeLayer);
                    break;
                case BASE:
                    map.getBasemap().getBaseLayers().add(nativeLayer);
                    break;
                case REFERENCE:
                    map.getBasemap().getReferenceLayers().add(nativeLayer);
                    break;
            }
        }
    }

    private void removeLayersFromMap(Collection<FlutterLayer> layers, LayerType layerType) {
        if (layers.size() == 0)
            return;
        final ArrayList<Layer> nativeLayersToRemove = new ArrayList<>();
        final Map<String, Layer> flutterMap = getFlutterMap(layerType);
        final Set<FlutterLayer> flutterLayer = getFlutterLayerSet(layerType);

        for (FlutterLayer layer : layers) {
            Layer nativeLayer = flutterMap.get(layer.getLayerId());
            flutterMap.remove(layer.getLayerId());
            flutterLayer.remove(layer);
            nativeLayersToRemove.add(nativeLayer);
        }

        if (map == null) {
            return;
        }

        switch (layerType) {
            case OPERATIONAL:
                map.getOperationalLayers().removeAll(nativeLayersToRemove);
                break;
            case BASE:
                map.getBasemap().getBaseLayers().removeAll(nativeLayersToRemove);
                break;
            case REFERENCE:
                map.getBasemap().getReferenceLayers().removeAll(nativeLayersToRemove);
                break;
        }
    }

    private String getObjectName(LayerType layerType) {
        switch (layerType) {
            case OPERATIONAL:
                return "operationalLayer";
            case BASE:
                return "baseLayer";
            case REFERENCE:
                return "referenceLayer";
            default:
                throw new UnsupportedOperationException();
        }
    }

    private Set<FlutterLayer> getFlutterLayerSet(LayerType layerType) {
        switch (layerType) {
            case OPERATIONAL:
                return operationalLayers;
            case BASE:
                return baseLayers;
            case REFERENCE:
                return referenceLayers;
            default:
                throw new UnsupportedOperationException();
        }
    }


    private Map<String, Layer> getFlutterMap(LayerType layerType) {
        switch (layerType) {
            case OPERATIONAL:
                return flutterOperationalLayersMap;
            case BASE:
                return flutterBaseLayersMap;
            case REFERENCE:
                return flutterReferenceLayersMap;
            default:
                throw new UnsupportedOperationException();
        }
    }

    private void clearMap() {
        final Collection<Layer> operationalLayersNative = flutterOperationalLayersMap.values();
        final Collection<Layer> baseLayersNative = flutterBaseLayersMap.values();
        final Collection<Layer> referenceLayersNative = flutterReferenceLayersMap.values();

        flutterOperationalLayersMap.clear();
        flutterBaseLayersMap.clear();
        flutterReferenceLayersMap.clear();

        if (map == null) {
            return;
        }
        map.getOperationalLayers().removeAll(operationalLayersNative);
        map.getBasemap().getBaseLayers().removeAll(baseLayersNative);
        map.getBasemap().getReferenceLayers().removeAll(referenceLayersNative);
    }
}
