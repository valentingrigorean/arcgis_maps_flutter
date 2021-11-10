package com.valentingrigorean.arcgis_maps_flutter.map;

import android.content.Context;
import android.util.Log;
import android.view.MotionEvent;

import com.esri.arcgisruntime.concurrent.ListenableFuture;
import com.esri.arcgisruntime.geometry.Point;
import com.esri.arcgisruntime.mapping.view.DefaultMapViewOnTouchListener;
import com.esri.arcgisruntime.mapping.view.Graphic;
import com.esri.arcgisruntime.mapping.view.IdentifyGraphicsOverlayResult;
import com.esri.arcgisruntime.mapping.view.IdentifyLayerResult;
import com.esri.arcgisruntime.mapping.view.MapView;
import com.valentingrigorean.arcgis_maps_flutter.Convert;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import io.flutter.plugin.common.MethodChannel;

public class MapViewOnTouchListener extends DefaultMapViewOnTouchListener {

    private static final String TAG = "MapViewOnTouchListener";

    private final ArrayList<MapTouchGraphicDelegate> mapTouchGraphicDelegates = new ArrayList<>();
    private final MethodChannel methodChannel;

    private ListenableFuture<List<IdentifyGraphicsOverlayResult>> graphicHandler;
    private ListenableFuture<List<IdentifyLayerResult>> layerHandler;

    private boolean trackIdentityLayers;


    public MapViewOnTouchListener(Context context, MapView mapView, MethodChannel methodChannel) {
        super(context, mapView);
        this.methodChannel = methodChannel;
    }

    public void setTrackIdentityLayers(boolean trackIdentityLayers) {
        this.trackIdentityLayers = trackIdentityLayers;
    }

    public void addGraphicDelegate(MapTouchGraphicDelegate mapTouchGraphicDelegate) {
        if (!mapTouchGraphicDelegates.contains(mapTouchGraphicDelegate))
            mapTouchGraphicDelegates.add(mapTouchGraphicDelegate);
    }

    public void clearAllDelegates() {
        mapTouchGraphicDelegates.clear();
    }

    @Override
    public boolean onSingleTapConfirmed(MotionEvent e) {

        clearHandlers();

        final android.graphics.Point screenPoint = new android.graphics.Point((int) e.getX(), (int) e.getY());

        if (canConsumeGraphics()) {
            Log.d(TAG, "onSingleTapConfirmed: identifyGraphicsOverlays");
            identifyGraphicsOverlays(screenPoint);
        } else if (trackIdentityLayers) {
            Log.d(TAG, "onSingleTapConfirmed: identifyLayers");
            identifyLayers(screenPoint);
        } else {
            sendOnMapTap(screenPoint);
        }

        return true;
    }

    @Override
    public void onLongPress(MotionEvent e) {
        super.onLongPress(e);
        final android.graphics.Point screenPoint = new android.graphics.Point((int) e.getX(), (int) e.getY());
        sendOnMapLongPress(screenPoint);
    }

    private void identifyGraphicsOverlays(android.graphics.Point screenPoint) {
        graphicHandler = mMapView.identifyGraphicsOverlaysAsync(screenPoint, 12, false);
        graphicHandler.addDoneListener(() -> {
            try {
                final List<IdentifyGraphicsOverlayResult> results = graphicHandler.get();
                graphicHandler = null;
                Log.d(TAG, "identifyGraphicsOverlays: " + results.size() + " found.");
                if (onTapCompleted(results, screenPoint)) {
                    return;
                }
                if (trackIdentityLayers) {
                    identifyLayers(screenPoint);
                } else {
                    sendOnMapTap(screenPoint);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        });
    }

    private void identifyLayers(android.graphics.Point screenPoint) {
        layerHandler = mMapView.identifyLayersAsync(screenPoint, 10, false);
        layerHandler.addDoneListener(() -> {
            try {
                final List<IdentifyLayerResult> results = layerHandler.get();
                layerHandler = null;
                Log.d(TAG, "identifyLayers: " + results.size() + " found.");
                if (results.size() == 0) {
                    sendOnMapTap(screenPoint);
                    return;
                }
                final Object json = Convert.identifyLayerResultsToJson(results);
                methodChannel.invokeMethod("map#onIdentifyLayers", json);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        });
    }

    private boolean onTapCompleted(List<IdentifyGraphicsOverlayResult> results, android.graphics.Point screenPoint) {
        if (results != null) {
            for (final IdentifyGraphicsOverlayResult result : results) {
                for (final MapTouchGraphicDelegate touchDelegate : mapTouchGraphicDelegates) {
                    for (final Graphic graphic : result.getGraphics()) {
                        if (touchDelegate.didHandleGraphic(graphic)) {
                            return true;
                        }
                    }
                }
            }
        }
        return false;
    }

    private void sendOnMapTap(android.graphics.Point screenPoint) {
        final Point mapPoint = mMapView.screenToLocation(screenPoint);
        final HashMap<String, Object> data = new HashMap<>(1);
        data.put("position", Convert.geometryToJson(mapPoint));
        methodChannel.invokeMethod("map#onTap", data);
    }

    private void sendOnMapLongPress(android.graphics.Point screenPoint) {
        final Point mapPoint = mMapView.screenToLocation(screenPoint);

        final HashMap<String, Object> data = new HashMap<>(1);
        data.put("position", Convert.geometryToJson(mapPoint));
        methodChannel.invokeMethod("map#onLongPress", data);
    }

    private void clearHandlers() {
        if (graphicHandler != null) {
            graphicHandler.cancel(true);
            graphicHandler = null;
        }
        if (layerHandler != null) {
            layerHandler.cancel(true);
            layerHandler = null;
        }
    }

    private boolean canConsumeGraphics() {
        boolean result = false;

        for (final MapTouchGraphicDelegate touchDelegate : mapTouchGraphicDelegates) {
            if (touchDelegate.canConsumeTaps()) {
                result = true;
                break;
            }
        }
        return result;
    }
}
