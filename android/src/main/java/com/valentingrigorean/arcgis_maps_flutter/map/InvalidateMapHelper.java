package com.valentingrigorean.arcgis_maps_flutter.map;

import android.util.Log;
import android.view.Choreographer;

import com.esri.arcgisruntime.mapping.view.DrawStatusChangedEvent;
import com.esri.arcgisruntime.mapping.view.DrawStatusChangedListener;
import com.esri.arcgisruntime.mapping.view.GeoView;
import com.esri.arcgisruntime.mapping.view.LayerViewStateChangedEvent;
import com.esri.arcgisruntime.mapping.view.LayerViewStateChangedListener;
import com.esri.arcgisruntime.mapping.view.LayerViewStatus;

public class InvalidateMapHelper implements DrawStatusChangedListener, LayerViewStateChangedListener {
    private static final String TAG = InvalidateMapHelper.class.getSimpleName();

    private final GeoView mapView;
    private boolean loadedCallbackPending = false;
    private boolean isDisposed = false;

    public InvalidateMapHelper(GeoView mapView) {
        this.mapView = mapView;
        mapView.addDrawStatusChangedListener(this);
        mapView.addLayerViewStateChangedListener(this);
    }

    public void dispose() {
        if (isDisposed) {
            return;
        }
        isDisposed = true;
        mapView.removeLayerViewStateChangedListener(this);
        mapView.removeDrawStatusChangedListener(this);
    }

    /**
     * Invalidates the map view after the map has finished rendering.
     *
     * <p>gmscore GL renderer uses a {@link android.view.TextureView}. Android platform views that are
     * displayed as a texture after Flutter v3.0.0. require that the view hierarchy is notified after
     * all drawing operations have been flushed.
     *
     * <p>Since the GL renderer doesn't use standard Android views, and instead uses GL directly, we
     * notify the view hierarchy by invalidating the view.
     *
     * <p>To workaround this limitation, wait two frames. This ensures that at least the frame budget
     * (16.66ms at 60hz) have passed since the drawing operation was issued.
     */
    public void invalidateMapIfNeeded() {
        if (loadedCallbackPending) {
            return;
        }
        loadedCallbackPending = true;
    }

    @Override
    public void drawStatusChanged(DrawStatusChangedEvent drawStatusChangedEvent) {
        Log.d(TAG, "drawStatusChanged: " + drawStatusChangedEvent.getDrawStatus().name());

        if (!loadedCallbackPending) {
            Log.d(TAG, "drawStatusChanged: invalidate map not needed");
            return;
        }

        switch (drawStatusChangedEvent.getDrawStatus()) {
            case COMPLETED:
                Log.d(TAG, "drawStatusChanged: invalidating map");
                loadedCallbackPending = false;
                postFrameCallback(() -> postFrameCallback(
                        () -> {
                            if (mapView != null && !isDisposed) {
                                mapView.invalidate();
                            }
                        }));
                break;
        }
    }

    @Override
    public void layerViewStateChanged(LayerViewStateChangedEvent layerViewStateChangedEvent) {
        boolean needsInvalidate = false;
        for (LayerViewStatus layerViewStatus : layerViewStateChangedEvent.getLayerViewStatus()) {
            if (layerViewStatus == LayerViewStatus.ACTIVE) {
                needsInvalidate = true;
                break;
            }
        }
        if (needsInvalidate) {
            invalidateMapIfNeeded();
        }
    }

    private static void postFrameCallback(Runnable f) {
        Choreographer.getInstance()
                .postFrameCallback(frameTimeNanos -> f.run());
    }
}
