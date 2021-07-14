package com.valentingrigorean.arcgis_maps_flutter.map;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;

import com.esri.arcgisruntime.concurrent.ListenableFuture;
import com.esri.arcgisruntime.layers.Layer;
import com.esri.arcgisruntime.layers.LayerContent;
import com.esri.arcgisruntime.layers.LegendInfo;
import com.valentingrigorean.arcgis_maps_flutter.Convert;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;

public class LegendInfoController {
    private final Context context;
    private final LayersController layersController;
    private final MethodChannel.Result result;

    private Map<LayerContent, List<LegendInfo>> layersLegends = new HashMap<>();

    private boolean didSetResult;

    private int requests = 0;


    public LegendInfoController(Context context, LayersController layersController, MethodChannel.Result result) {
        this.context = context;
        this.layersController = layersController;
        this.result = result;
    }

    public void loadAsync(Object args) {
        if (didSetResult) {
            return;
        }
        final Map<?, ?> data = Convert.toMap(args);
        if (data == null || data.isEmpty()) {
            setResult();
            return;
        }

        final FlutterLayer flutterLayer = new FlutterLayer(data);

        Layer loadedLayer = layersController.getLayerByLayerId(flutterLayer.getLayerId());
        if (loadedLayer == null) {
            loadedLayer = flutterLayer.createLayer();
        }
        loadIndividualLayer(loadedLayer);
    }

    private void loadIndividualLayer(LayerContent layerContent) {
        if (layerContent instanceof Layer) {
            final Layer layer = (Layer) layerContent;
            layer.addDoneLoadingListener(() -> {
                if (layer.canShowInLegend())
                    loadSublayersOrLegendInfos(layer);
            });
            layer.loadAsync();
        } else {
            loadSublayersOrLegendInfos(layerContent);
        }
    }

    private void loadSublayersOrLegendInfos(LayerContent layerContent) {
        if (!layerContent.getSubLayerContents().isEmpty()) {
            for (final LayerContent layer :
                    layerContent.getSubLayerContents()) {
                loadIndividualLayer(layer);
            }
        } else {
            requests++;
            final ListenableFuture<List<LegendInfo>> future = layerContent.fetchLegendInfosAsync();

            future.addDoneListener(() -> {
                try {
                    final List<LegendInfo> items = future.get();
                    layersLegends.put(layerContent, items);
                    requests--;
                    if (requests <= 0) {
                        setResult();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            });
        }
    }


    private void setResult() {
        if (didSetResult)
            return;
        didSetResult = true;

        final ArrayList<Object> items = new ArrayList<>(layersLegends.size());

        if (layersLegends.isEmpty()) {
            result.success(items);
            return;
        }

        layersLegends.forEach((k, v) -> {
            final ArrayList<Map<?, ?>> legendItemsForLayer = new ArrayList<>(layersLegends.size());

            for (final LegendInfo legendInfo : v) {
                final Map<String, Object> item = new HashMap<>(2);
                item.put("name", legendInfo.getName());

                final ListenableFuture<Bitmap> future = legendInfo.getSymbol().createSwatchAsync(context, Color.TRANSPARENT);
                final LayerContent layerContent = k;
                future.addDoneListener(() -> {
                    try {
                        final Bitmap bitmap = future.get();
                        final ByteArrayOutputStream stream = new ByteArrayOutputStream();
                        bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream);
                        item.put("symbolImage", stream.toByteArray());
                    } catch (Exception e) {
                        item.put("symbolImage", new byte[0]);
                        e.printStackTrace();
                    }

                    legendItemsForLayer.add(item);

                    if (legendItemsForLayer.size() == v.size()) {
                        final Map<String, Object> resultItem = new HashMap<>(2);
                        resultItem.put("layerName", layerContent.getName());
                        resultItem.put("results", legendItemsForLayer);
                        items.add(resultItem);
                        if (items.size() == layersLegends.size()) {
                            result.success(items);
                        }
                    }
                });
            }
        });


    }
}
