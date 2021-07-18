package com.valentingrigorean.arcgis_maps_flutter.map;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.util.Log;

import com.esri.arcgisruntime.concurrent.ListenableFuture;
import com.esri.arcgisruntime.layers.FeatureLayer;
import com.esri.arcgisruntime.layers.Layer;
import com.esri.arcgisruntime.layers.LayerContent;
import com.esri.arcgisruntime.layers.LegendInfo;
import com.esri.arcgisruntime.loadable.LoadStatus;
import com.valentingrigorean.arcgis_maps_flutter.Convert;

import org.jetbrains.annotations.NotNull;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class LegendInfoController {

    private final String TAG = "LegendInfoController";

    private final Context context;
    private final LayersController layersController;

    private Map<LayerContent, List<LegendInfo>> layersLegends = new HashMap<>();
    private List<Object> legendResultsFlutter = new ArrayList<>();

    private boolean didSetResult;

    private LegendInfoControllerResult legendInfoControllerResult;

    private ArrayList<LayerContent> pendingLayersRequests = new ArrayList<>();


    public interface LegendInfoControllerResult {
        void onResult(List<Object> results);
    }


    public LegendInfoController(Context context, LayersController layersController) {
        this.context = context;
        this.layersController = layersController;
    }

    public void loadAsync(Object args, @NotNull LegendInfoControllerResult legendInfoControllerResult) {
        if (didSetResult) {
            legendInfoControllerResult.onResult(legendResultsFlutter);
            return;
        }
        this.legendInfoControllerResult = legendInfoControllerResult;
        final Map<?, ?> data = Convert.toMap(args);
        if (data == null || data.isEmpty()) {
            setResult();
            return;
        }

        final FlutterLayer flutterLayer = new FlutterLayer(data);

        Layer loadedLayer = layersController.getLayerByLayerId(flutterLayer.getLayerId());
        if (loadedLayer == null) {
            Log.d(TAG, "loadAsync: " + flutterLayer.getLayerId() + " not found. Creating a new layer.");
            loadedLayer = flutterLayer.createLayer();
        } else {
            Log.d(TAG, "loadAsync: " + flutterLayer.getLayerId() + " found in map layers.");
        }

        final Layer layer = loadedLayer;

        final Runnable onDone = () -> {
            Log.d(TAG, "loadAsync: " + layer.getName() + " status -> " + layer.getLoadStatus());
            if (layer.getLoadStatus() != LoadStatus.LOADED) {
                setResult();
            } else if (!layer.canShowInLegend() && layer.getSubLayerContents().isEmpty()) {
                setResult();
            } else {
                loadSublayersOrLegendInfos(layer);
            }
        };

        if (loadedLayer instanceof FeatureLayer) {
            final FeatureLayer featureLayer = (FeatureLayer) loadedLayer;
            featureLayer.getFeatureTable().addDoneLoadingListener(() -> {
                featureLayer.addDoneLoadingListener(onDone);
                featureLayer.loadAsync();
            });
        } else {
            layer.addDoneLoadingListener(onDone);
        }

        loadedLayer.loadAsync();
    }

    private void loadIndividualLayer(LayerContent layerContent) {
        if (layerContent instanceof Layer) {
            final Layer layer = (Layer) layerContent;
            final Runnable onDone = () -> {
                Log.d(TAG, "loadIndividualLayer: " + layer.getName() + " status -> " + layer.getLoadStatus());
                loadSublayersOrLegendInfos(layer);
            };
            if (layer instanceof FeatureLayer) {
                final FeatureLayer featureLayer = (FeatureLayer) layer;
                featureLayer.getFeatureTable().addDoneLoadingListener(() -> {
                    featureLayer.addDoneLoadingListener(onDone);
                    featureLayer.loadAsync();
                });
            } else {
                layer.addDoneLoadingListener(onDone);
            }
            layer.loadAsync();
        } else {
            loadSublayersOrLegendInfos(layerContent);
        }
    }

    private void loadSublayersOrLegendInfos(LayerContent layerContent) {

        if (!layerContent.getSubLayerContents().isEmpty()) {
            pendingLayersRequests.add(layerContent);
            Log.d(TAG, "loadSublayersOrLegendInfos: " + layerContent.getName() + " loading sublayers -> " + layerContent.getSubLayerContents().size() + " pendingRequest " + pendingLayersRequests.size());
            for (final LayerContent layer :
                    layerContent.getSubLayerContents()) {
                loadIndividualLayer(layer);
            }

            pendingLayersRequests.remove(layerContent);
        } else {
            final ListenableFuture<List<LegendInfo>> future = layerContent.fetchLegendInfosAsync();

            pendingLayersRequests.add(layerContent);
            Log.d(TAG, "loadSublayersOrLegendInfos: Loading legend for " + layerContent.getName() + " pendingRequest " + pendingLayersRequests.size());
            future.addDoneListener(() -> {
                pendingLayersRequests.remove(layerContent);
                Log.d(TAG, "loadSublayersOrLegendInfos: Finish loading legend for " + layerContent.getName() + " pendingRequest " + pendingLayersRequests.size());

                try {
                    final List<LegendInfo> items = future.get();
                    layersLegends.put(layerContent, items);

                    if (pendingLayersRequests.size() == 0) {
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
            Log.d(TAG, "onResult: " + legendResultsFlutter.size());
            legendInfoControllerResult.onResult(legendResultsFlutter);
        }
    }

    private void createLegendFlutter(LayerContent layerContent, List<LegendInfo> legendInfos) {
        final ArrayList<Map<?, ?>> results = new ArrayList<>(legendInfos.size());
        if (legendInfos.isEmpty()) {
            addLegendInfoResultFlutterAndValidate(layerContent, results);
            return;
        }
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
            legendInfoControllerResult.onResult(items);
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
