package com.valentingrigorean.arcgis_maps_flutter.map;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;

import com.esri.arcgisruntime.concurrent.ListenableFuture;
import com.esri.arcgisruntime.layers.Layer;
import com.esri.arcgisruntime.layers.LayerContent;
import com.esri.arcgisruntime.layers.LegendInfo;
import com.esri.arcgisruntime.loadable.LoadStatus;
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
    private List<Object> legendResultsFlutter = new ArrayList<>();

    private boolean didSetResult;

    private int pendingRequest = 0;


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

        final Layer layer = loadedLayer;
        layer.addDoneLoadingListener(() -> {
            if (layer.getLoadStatus() != LoadStatus.LOADED) {
                setResult();
            } else if (!layer.canShowInLegend() && layer.getSubLayerContents().isEmpty()) {
                setResult();
            }
        });

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
            pendingRequest++;
            for (final LayerContent layer :
                    layerContent.getSubLayerContents()) {
                loadIndividualLayer(layer);
            }
            pendingRequest--;
        } else {
            final ListenableFuture<List<LegendInfo>> future = layerContent.fetchLegendInfosAsync();

            pendingRequest++;
            future.addDoneListener(() -> {
                try {
                    final List<LegendInfo> items = future.get();
                    layersLegends.put(layerContent, items);

                    pendingRequest--;
                    if (pendingRequest == 0) {
                        setResult();
                    }
                } catch (Exception e) {
                    layersLegends.put(layerContent, new ArrayList<>(0));
                    e.printStackTrace();
                }
            });
        }
    }

    private void addLegendInfoResultFlutterAndValidate(LayerContent layerContent, List<?> results) {
        final Map<String, Object> item = new HashMap<>(2);
        item.put("layerName", layerContent.getName());
        item.put("results", results);

        legendResultsFlutter.add(item);
        if (legendResultsFlutter.size() == layersLegends.size()) {
            result.success(legendResultsFlutter);
        }
    }

    private void createLegendFlutter(LayerContent layerContent, List<LegendInfo> legendInfos) {
        final ArrayList<Map<?, ?>> results = new ArrayList<>(legendInfos.size());
        for (final LegendInfo legendInfo : legendInfos) {
            final Map<String, Object> item = new HashMap<>(2);
            item.put("name", legendInfo.getName());

            if (legendInfo.getSymbol() == null) {
                results.add(item);

                if (validateLayerResults(legendInfos, results)) {
                    addLegendInfoResultFlutterAndValidate(layerContent, results);
                }
            } else {
                {
                    final ListenableFuture<Bitmap> future = legendInfo.getSymbol().createSwatchAsync(context, Color.TRANSPARENT);
                    future.addDoneListener(() -> {
                        try {
                            final Bitmap bitmap = future.get();
                            final ByteArrayOutputStream stream = new ByteArrayOutputStream();
                            bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream);
                            item.put("symbolImage", stream.toByteArray());
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        results.add(item);

                        if (validateLayerResults(legendInfos, results)) {
                            addLegendInfoResultFlutterAndValidate(layerContent, results);
                        }
                    });
                }
            }
        }
    }


    private void setResult() {
        if (didSetResult)
            return;
        didSetResult = true;

        if (layersLegends.isEmpty()) {
            final ArrayList<Object> items = new ArrayList<>(0);
            result.success(items);
            return;
        }

        layersLegends.forEach((k, v) -> {
            createLegendFlutter(k, v);
        });
    }

    private static boolean validateLayerResults(List<?> src, List<?> dst) {
        return src.size() == dst.size();
    }
}
