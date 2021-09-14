package com.valentingrigorean.arcgis_maps_flutter.layers;

import android.net.Uri;

import com.esri.arcgisruntime.arcgisservices.TileInfo;
import com.esri.arcgisruntime.data.TileKey;
import com.esri.arcgisruntime.geometry.Envelope;
import com.esri.arcgisruntime.layers.ServiceImageTiledLayer;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class FlutterServiceImageTiledLayer extends ServiceImageTiledLayer {
    private final String urlTemplate;
    private final List<String> subdomains;
    private final Map<String, String> additionalOptions;

    protected FlutterServiceImageTiledLayer(TileInfo tileInfo, Envelope fullExtent, String urlTemplate, List<String> subdomains, Map<String, String> additionalOptions) {
        super(tileInfo, fullExtent);
        this.urlTemplate = urlTemplate;
        this.subdomains = subdomains;
        this.additionalOptions = additionalOptions;
    }

    @Override
    protected String getTileUrl(TileKey tileKey) {
        final String url = urlTemplate.replace("{z}", String.valueOf(tileKey.getLevel()))
                .replace("{x}", String.valueOf(tileKey.getColumn()))
                .replace("{y}", String.valueOf(tileKey.getRow()));

        if (subdomains.size() == 0 || !url.contains("{s}")) {
            return createUrl(url);
        }

        final int subdomain = tileKey.getLevel() + tileKey.getRow() + tileKey.getColumn();

        return createUrl(url.replace("{s}", subdomains.get(subdomain % subdomains.size())));
    }

    @Override
    public String getUri() {
        return null;
    }

    private String createUrl(String url) {
        if (additionalOptions.size() == 0) {
            return url;
        }

        final Uri.Builder builder = Uri.parse(url).buildUpon();
        additionalOptions.forEach((key, value) -> {
            builder.appendQueryParameter(key, value);
        });
        return builder.build().getPath();
    }
}
