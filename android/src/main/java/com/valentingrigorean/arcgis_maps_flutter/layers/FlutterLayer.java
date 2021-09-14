package com.valentingrigorean.arcgis_maps_flutter.layers;

import com.esri.arcgisruntime.arcgisservices.TileInfo;
import com.esri.arcgisruntime.data.ServiceFeatureTable;
import com.esri.arcgisruntime.geometry.Envelope;
import com.esri.arcgisruntime.io.RemoteResource;
import com.esri.arcgisruntime.layers.ArcGISMapImageLayer;
import com.esri.arcgisruntime.layers.ArcGISTiledLayer;
import com.esri.arcgisruntime.layers.ArcGISVectorTiledLayer;
import com.esri.arcgisruntime.layers.FeatureLayer;
import com.esri.arcgisruntime.layers.Layer;
import com.esri.arcgisruntime.layers.WmsLayer;
import com.esri.arcgisruntime.security.Credential;
import com.valentingrigorean.arcgis_maps_flutter.Convert;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Objects;

public class FlutterLayer {
    private final Map<?, ?> data;
    private final String layerId;
    private final String layerType;
    private final String url;
    private final Credential credential;
    private final boolean isVisible;
    private final float opacity;
    private final ServiceImageTiledLayerOptions serviceImageTiledLayerOptions;

    public FlutterLayer(Map<?, ?> data) {
        this.data = data;
        layerId = (String) data.get("layerId");
        layerType = (String) data.get("layerType");
        url = (String) data.get("url");
        isVisible = Convert.toBoolean(data.get("isVisible"));
        opacity = Convert.toFloat(data.get("opacity"));
        if (data.containsKey("credential")) {
            credential = Convert.toCredentials(data.get("credential"));
        } else {
            credential = null;
        }

        if (layerType.equals("ServiceImageTiledLayer")) {
            serviceImageTiledLayerOptions = Convert.toServiceImageTiledLayerOptions(data);
        } else {
            serviceImageTiledLayerOptions = null;
        }
    }

    public String getLayerId() {
        return layerId;
    }

    public Layer createLayer() {
        Layer layer;
        RemoteResource remoteResource = null;
        switch (layerType) {
            case "VectorTileLayer":
                final ArcGISVectorTiledLayer vectorTiledLayer = new ArcGISVectorTiledLayer(url);
                layer = vectorTiledLayer;
                remoteResource = vectorTiledLayer;
                break;
            case "FeatureLayer":
                final ServiceFeatureTable serviceFeatureTable = new ServiceFeatureTable(url);
                remoteResource = serviceFeatureTable;
                layer = new FeatureLayer(serviceFeatureTable);
                break;
            case "TiledLayer":
                final ArcGISTiledLayer tiledLayer = new ArcGISTiledLayer(url);
                remoteResource = tiledLayer;
                layer = tiledLayer;
                break;
            case "WmsLayer":
                final Collection<String> layersNames = (Collection<String>) data.get("layersName");
                final WmsLayer wmsLayer = new WmsLayer(url, layersNames);
                remoteResource = wmsLayer;
                layer = wmsLayer;
                break;
            case "MapImageLayer":
                final ArcGISMapImageLayer mapImageLayer = new ArcGISMapImageLayer(url);
                remoteResource = mapImageLayer;
                layer = mapImageLayer;
                break;
            case "ServiceImageTiledLayer":
                layer = new FlutterServiceImageTiledLayer(serviceImageTiledLayerOptions.tileInfo, serviceImageTiledLayerOptions.fullExtent,
                        serviceImageTiledLayerOptions.urlTemplate, serviceImageTiledLayerOptions.subdomains,
                        serviceImageTiledLayerOptions.additionalOptions);
                break;
            default:
                throw new UnsupportedOperationException("not implemented.");
        }

        if (credential != null && remoteResource != null) {
            remoteResource.setCredential(credential);
        }

        layer.setOpacity(opacity);
        layer.setVisible(isVisible);

        return layer;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        FlutterLayer that = (FlutterLayer) o;
        return isVisible == that.isVisible && Float.compare(that.opacity, opacity) == 0 && Objects.equals(layerId, that.layerId) && Objects.equals(layerType, that.layerType) && Objects.equals(url, that.url) && Objects.equals(credential, that.credential) && Objects.equals(serviceImageTiledLayerOptions, that.serviceImageTiledLayerOptions);
    }

    @Override
    public int hashCode() {
        return Objects.hash(layerId, layerType, url, credential, isVisible, opacity, serviceImageTiledLayerOptions);
    }


    public static final class ServiceImageTiledLayerOptions {
        private final TileInfo tileInfo;
        private final Envelope fullExtent;
        private final String urlTemplate;
        private final List<String> subdomains;
        private final Map<String, String> additionalOptions;

        public ServiceImageTiledLayerOptions(TileInfo tileInfo, Envelope fullExtent, String urlTemplate,
                                             List<String> subdomains, Map<String, String> additionalOptions) {
            this.tileInfo = tileInfo;
            this.fullExtent = fullExtent;
            this.urlTemplate = urlTemplate;
            this.subdomains = subdomains;
            this.additionalOptions = additionalOptions;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;
            ServiceImageTiledLayerOptions that = (ServiceImageTiledLayerOptions) o;
            return Objects.equals(tileInfo, that.tileInfo) && Objects.equals(fullExtent, that.fullExtent) && Objects.equals(urlTemplate, that.urlTemplate) && Objects.equals(subdomains, that.subdomains) && Objects.equals(additionalOptions, that.additionalOptions);
        }

        @Override
        public int hashCode() {
            return Objects.hash(tileInfo, fullExtent, urlTemplate, subdomains, additionalOptions);
        }
    }


}
