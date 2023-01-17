package com.valentingrigorean.arcgis_maps_flutter.map;

import android.graphics.Bitmap;

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

public interface FlutterMapViewDelegate {

    void dispose();

    void resume();

    void pause();

    @Nullable
    MapView getMapView();

    SelectionProperties getSelectionProperties();

    ArcGISMap getMap();

    void setMap(ArcGISMap map);

    MapView.InteractionOptions getInteractionOptions();

    void setAttributionTextVisible(boolean visible);

    void setViewInsets(double left, double top, double right, double bottom);

    double getMapScale();

    double getMapRotation();

    LocationDisplay getLocationDisplay();

    ListenableFuture<Bitmap> exportImageAsync();

    ListenableList<GraphicsOverlay> getGraphicsOverlays();

    Viewpoint getCurrentViewpoint(Viewpoint.Type type);

    ListenableFuture<Boolean> setViewpointAsync(Viewpoint viewpoint);

    ListenableFuture<Boolean> setViewpointAsync(Viewpoint viewpoint, float durationSeconds);

    ListenableFuture<Boolean> setViewpointGeometryAsync(Geometry geometry);

    ListenableFuture<Boolean> setViewpointGeometryAsync(Geometry geometry, double padding);

    ListenableFuture<Boolean> setViewpointCenterAsync(Point point, double scale);

    ListenableFuture<Boolean> setViewpointScaleAsync(double scale);

    ListenableFuture<Boolean> setViewpointRotationAsync(double rotation);

    android.graphics.Point locationToScreen(Point point);

    Point screenToLocation(android.graphics.Point point);

    TimeExtent getTimeExtent();

    void setTimeExtent(TimeExtent timeExtent);

    void addViewpointChangedListener(ViewpointChangedListener listener);

    void removeViewpointChangedListener(ViewpointChangedListener listener);

    void addDrawStatusChangedListener(DrawStatusChangedListener listener);

    void removeDrawStatusChangedListener(DrawStatusChangedListener listener);

    void addLayerViewStateChangedListener(LayerViewStateChangedListener listener);

    void removeLayerViewStateChangedListener(LayerViewStateChangedListener listener);

    void addMapScaleChangedListener(MapScaleChangedListener listener);

    void removeMapScaleChangedListener(MapScaleChangedListener listener);

    void addTimeExtentChangedListener(TimeExtentChangedListener listener);

    void removeTimeExtentChangedListener(TimeExtentChangedListener listener);


}
