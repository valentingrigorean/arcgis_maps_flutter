package com.valentingrigorean.arcgis_maps_flutter.map;

import android.content.Context;
import android.graphics.Bitmap;
import android.util.AttributeSet;
import android.util.Log;
import android.view.MotionEvent;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import androidx.annotation.Nullable;

import com.esri.arcgisruntime.concurrent.ListenableFuture;
import com.esri.arcgisruntime.geometry.Geometry;
import com.esri.arcgisruntime.geometry.Point;
import com.esri.arcgisruntime.mapping.ArcGISMap;
import com.esri.arcgisruntime.mapping.SelectionProperties;
import com.esri.arcgisruntime.mapping.TimeExtent;
import com.esri.arcgisruntime.mapping.Viewpoint;
import com.esri.arcgisruntime.mapping.view.DrawStatusChangedListener;
import com.esri.arcgisruntime.mapping.view.GraphicsOverlay;
import com.esri.arcgisruntime.mapping.view.LayerViewStateChangedListener;
import com.esri.arcgisruntime.mapping.view.LocationDisplay;
import com.esri.arcgisruntime.mapping.view.MapScaleChangedListener;
import com.esri.arcgisruntime.mapping.view.MapView;
import com.esri.arcgisruntime.mapping.view.TimeExtentChangedListener;
import com.esri.arcgisruntime.mapping.view.ViewpointChangedListener;
import com.esri.arcgisruntime.util.ListenableList;

import java.util.ArrayList;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

public class FlutterMapView extends FrameLayout implements FlutterMapViewDelegate {
    private final MapView mapView;
    private final ArrayList<ViewpointChangedListener> viewpointChangedListeners = new ArrayList<>();
    private final ArrayList<DrawStatusChangedListener> drawStatusChangedListeners = new ArrayList<>();
    private final ArrayList<LayerViewStateChangedListener> layerViewStateChangedListeners = new ArrayList<>();
    private final ArrayList<MapScaleChangedListener> mapScaleChangedListeners = new ArrayList<>();
    private final ArrayList<TimeExtentChangedListener> timeExtentChangedListeners = new ArrayList<>();

    private boolean isDisposed = false;

    public FlutterMapView(Context context, AttributeSet attrs) {
        super(context, attrs);
        mapView = new MapView(context);
        setupMapView();
    }

    public FlutterMapView(Context context) {
        super(context);
        mapView = new MapView(context);
        setupMapView();
    }


    @Override
    protected void finalize() throws Throwable {
        dispose();
        super.finalize();
    }

    @Override
    public void dispose() {
        if (isDisposed) {
            return;
        }
        isDisposed = true;
        for (final ViewpointChangedListener listener : viewpointChangedListeners) {
            mapView.removeViewpointChangedListener(listener);
        }
        viewpointChangedListeners.clear();
        for (final DrawStatusChangedListener listener : drawStatusChangedListeners) {
            mapView.removeDrawStatusChangedListener(listener);
        }
        drawStatusChangedListeners.clear();
        for (final LayerViewStateChangedListener listener : layerViewStateChangedListeners) {
            mapView.removeLayerViewStateChangedListener(listener);
        }
        layerViewStateChangedListeners.clear();
        for (final MapScaleChangedListener listener : mapScaleChangedListeners) {
            mapView.removeMapScaleChangedListener(listener);
        }
        mapScaleChangedListeners.clear();
        for (final TimeExtentChangedListener listener : timeExtentChangedListeners) {
            mapView.removeTimeExtentChangedListener(listener);
        }
        timeExtentChangedListeners.clear();


        mapView.dispose();
    }

    @Override
    public void resume() {
        if (isDisposed) {
            return;
        }
        mapView.resume();
    }

    @Override
    public void pause() {
        if (isDisposed) {
            return;
        }
        mapView.pause();
    }

    @Nullable
    @Override
    public MapView getMapView() {
        return isDisposed ? null : mapView;
    }

    @Override
    public SelectionProperties getSelectionProperties() {
        if (isDisposed) {
            return null;
        }
        return mapView.getSelectionProperties();
    }

    @Override
    public ArcGISMap getMap() {
        return isDisposed ? null : mapView.getMap();
    }

    @Override
    public void setMap(ArcGISMap map) {
        if (isDisposed) {
            return;
        }
        mapView.setMap(map);
    }

    @Override
    public MapView.InteractionOptions getInteractionOptions() {
        return isDisposed ? null : mapView.getInteractionOptions();
    }

    @Override
    public void setAttributionTextVisible(boolean visible) {
        if (isDisposed) {
            return;
        }
        mapView.setAttributionTextVisible(visible);
    }

    @Override
    public void setViewInsets(double left, double top, double right, double bottom) {
        if (isDisposed) {
            return;
        }
        mapView.setViewInsets(left, top, right, bottom);
    }

    @Override
    public double getMapScale() {
        if (isDisposed) {
            return 0;
        }
        try {
            return mapView.getMapScale();
        } catch (Exception e) {
            Log.e("FlutterMapView", "getMapScale", e);
            return 0;
        }
    }

    @Override
    public double getMapRotation() {
        if (isDisposed) {
            return 0;
        }
        try {
            return mapView.getMapRotation();
        } catch (Exception e) {
            Log.e("FlutterMapView", "getMapRotation", e);
            return 0;
        }
    }

    @Override
    public LocationDisplay getLocationDisplay() {
        return isDisposed ? null : mapView.getLocationDisplay();
    }

    @Override
    public ListenableFuture<Bitmap> exportImageAsync() {
        return isDisposed ? new ValueListenableFutureExt<>(null) : mapView.exportImageAsync();
    }

    @Override
    public ListenableList<GraphicsOverlay> getGraphicsOverlays() {
        return isDisposed ? null : mapView.getGraphicsOverlays();
    }

    @Override
    public Viewpoint getCurrentViewpoint(Viewpoint.Type type) {
        return isDisposed ? null : mapView.getCurrentViewpoint(type);
    }

    @Override
    public ListenableFuture<Boolean> setViewpointAsync(Viewpoint viewpoint) {
        return isDisposed ? new ValueListenableFutureExt<>(false) : mapView.setViewpointAsync(viewpoint);
    }

    @Override
    public ListenableFuture<Boolean> setViewpointAsync(Viewpoint viewpoint, float durationSeconds) {
        return isDisposed ? new ValueListenableFutureExt<>(false) : mapView.setViewpointAsync(viewpoint, durationSeconds);
    }

    @Override
    public ListenableFuture<Boolean> setViewpointGeometryAsync(Geometry geometry) {
        return isDisposed ? new ValueListenableFutureExt<>(false) : mapView.setViewpointGeometryAsync(geometry);
    }

    @Override
    public ListenableFuture<Boolean> setViewpointGeometryAsync(Geometry geometry, double padding) {
        return isDisposed ? new ValueListenableFutureExt<>(false) : mapView.setViewpointGeometryAsync(geometry, padding);
    }

    @Override
    public ListenableFuture<Boolean> setViewpointCenterAsync(Point point, double scale) {
        return isDisposed ? new ValueListenableFutureExt<>(false) : mapView.setViewpointCenterAsync(point, scale);
    }

    @Override
    public ListenableFuture<Boolean> setViewpointScaleAsync(double scale) {
        return isDisposed ? new ValueListenableFutureExt<>(false) : mapView.setViewpointScaleAsync(scale);
    }

    @Override
    public ListenableFuture<Boolean> setViewpointRotationAsync(double rotation) {
        return isDisposed ? new ValueListenableFutureExt<>(false) : mapView.setViewpointRotationAsync(rotation);
    }

    @Override
    public android.graphics.Point locationToScreen(Point point) {
        return isDisposed ? null : mapView.locationToScreen(point);
    }

    @Override
    public Point screenToLocation(android.graphics.Point point) {
        return isDisposed ? null : mapView.screenToLocation(point);
    }

    @Override
    public TimeExtent getTimeExtent() {
        return isDisposed ? null : mapView.getTimeExtent();
    }

    @Override
    public void setTimeExtent(TimeExtent timeExtent) {
        if (isDisposed) {
            return;
        }
        mapView.setTimeExtent(timeExtent);
    }

    @Override
    public void addViewpointChangedListener(ViewpointChangedListener listener) {
        if (isDisposed) {
            return;
        }
        viewpointChangedListeners.add(listener);
        mapView.addViewpointChangedListener(listener);
    }

    @Override
    public void removeViewpointChangedListener(ViewpointChangedListener listener) {
        if (isDisposed) {
            return;
        }
        viewpointChangedListeners.remove(listener);
        mapView.removeViewpointChangedListener(listener);
    }

    @Override
    public void addDrawStatusChangedListener(DrawStatusChangedListener listener) {
        if (isDisposed) {
            return;
        }
        drawStatusChangedListeners.add(listener);
        mapView.addDrawStatusChangedListener(listener);
    }

    @Override
    public void removeDrawStatusChangedListener(DrawStatusChangedListener listener) {
        if (isDisposed) {
            return;
        }
        drawStatusChangedListeners.remove(listener);
        mapView.removeDrawStatusChangedListener(listener);
    }

    @Override
    public void addLayerViewStateChangedListener(LayerViewStateChangedListener listener) {
        if (isDisposed) {
            return;
        }
        layerViewStateChangedListeners.add(listener);
        mapView.addLayerViewStateChangedListener(listener);
    }

    @Override
    public void removeLayerViewStateChangedListener(LayerViewStateChangedListener listener) {
        if (isDisposed) {
            return;
        }
        layerViewStateChangedListeners.remove(listener);
        mapView.removeLayerViewStateChangedListener(listener);
    }

    @Override
    public void addMapScaleChangedListener(MapScaleChangedListener listener) {
        if (isDisposed) {
            return;
        }
        mapScaleChangedListeners.add(listener);
        mapView.addMapScaleChangedListener(listener);
    }

    @Override
    public void removeMapScaleChangedListener(MapScaleChangedListener listener) {
        if (isDisposed) {
            return;
        }
        mapScaleChangedListeners.remove(listener);
        mapView.removeMapScaleChangedListener(listener);
    }

    @Override
    public void addTimeExtentChangedListener(TimeExtentChangedListener listener) {
        if (isDisposed) {
            return;
        }
        timeExtentChangedListeners.add(listener);
        mapView.addTimeExtentChangedListener(listener);
    }

    @Override
    public void removeTimeExtentChangedListener(TimeExtentChangedListener listener) {
        if (isDisposed) {
            return;
        }
        timeExtentChangedListeners.remove(listener);
        mapView.removeTimeExtentChangedListener(listener);
    }

    private void setupMapView() {
        addView(mapView, new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT));
    }


    private class ValueListenableFutureExt<T> implements ListenableFuture<T> {
        private final T value;

        private ValueListenableFutureExt(T value) {
            this.value = value;
        }

        @Override
        public void addDoneListener(Runnable runnable) {
            runnable.run();
        }

        @Override
        public boolean removeDoneListener(Runnable runnable) {
            return false;
        }

        @Override
        public boolean cancel(boolean b) {
            return true;
        }

        @Override
        public boolean isCancelled() {
            return false;
        }

        @Override
        public boolean isDone() {
            return true;
        }

        @Override
        public T get() throws ExecutionException, InterruptedException {
            return value;
        }

        @Override
        public T get(long l, TimeUnit timeUnit) throws ExecutionException, InterruptedException, TimeoutException {
            return value;
        }
    }
}

