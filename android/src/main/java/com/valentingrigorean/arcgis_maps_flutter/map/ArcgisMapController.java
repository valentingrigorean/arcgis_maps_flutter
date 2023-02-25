package com.valentingrigorean.arcgis_maps_flutter.map;

import android.content.Context;
import android.graphics.Bitmap;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.lifecycle.DefaultLifecycleObserver;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleOwner;

import com.esri.arcgisruntime.ArcGISRuntimeEnvironment;
import com.esri.arcgisruntime.arcgisservices.TimeAware;
import com.esri.arcgisruntime.concurrent.ListenableFuture;
import com.esri.arcgisruntime.geometry.Envelope;
import com.esri.arcgisruntime.geometry.Geometry;
import com.esri.arcgisruntime.geometry.GeometryEngine;
import com.esri.arcgisruntime.geometry.Point;
import com.esri.arcgisruntime.layers.Layer;
import com.esri.arcgisruntime.layers.ArcGISVectorTiledLayer;
import com.esri.arcgisruntime.loadable.LoadStatus;
import com.esri.arcgisruntime.mapping.ArcGISMap;
import com.esri.arcgisruntime.mapping.LayerList;
import com.esri.arcgisruntime.mapping.MobileMapPackage;
import com.esri.arcgisruntime.mapping.Basemap;
import com.esri.arcgisruntime.mapping.Viewpoint;
import com.esri.arcgisruntime.mapping.view.GraphicsOverlay;
import com.esri.arcgisruntime.mapping.view.MapView;
import com.esri.arcgisruntime.mapping.view.TimeExtentChangedEvent;
import com.esri.arcgisruntime.mapping.view.TimeExtentChangedListener;
import com.esri.arcgisruntime.mapping.view.ViewpointChangedEvent;
import com.esri.arcgisruntime.mapping.view.ViewpointChangedListener;
import com.valentingrigorean.arcgis_maps_flutter.Convert;
import com.valentingrigorean.arcgis_maps_flutter.LifecycleProvider;
import com.valentingrigorean.arcgis_maps_flutter.layers.LayersChangedController;
import com.valentingrigorean.arcgis_maps_flutter.layers.LayersController;
import com.valentingrigorean.arcgis_maps_flutter.layers.LegendInfoController;
import com.valentingrigorean.arcgis_maps_flutter.layers.MapChangeAware;
import com.valentingrigorean.arcgis_maps_flutter.utils.AGSLoadObjects;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutionException;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

final class ArcgisMapController implements DefaultLifecycleObserver, PlatformView, MethodChannel.MethodCallHandler, ViewpointChangedListener, TimeExtentChangedListener, LocationDisplayController.LocationDisplayControllerDelegate {

    private static final String TAG = "ArcgisMapController";

    private final Context context;
    private final LifecycleProvider lifecycleProvider;
    private final MethodChannel methodChannel;

    private final SelectionPropertiesHandler selectionPropertiesHandler;

    private final LayersController layersController;
    private final MarkersController markersController;
    private final PolygonsController polygonsController;
    private final PolylinesController polylinesController;

    private final ArrayList<SymbolsController> symbolControllers = new ArrayList<>();

    private final ArrayList<LegendInfoController> legendInfoControllers = new ArrayList<>();

    private final ArrayList<MapChangeAware> mapChangeAwares = new ArrayList<>();

    private final SymbolVisibilityFilterController symbolVisibilityFilterController;

    private final LayersChangedController layersChangedController;

    private final LocationDisplayController locationDisplayController;

    private final MapLoadedListener mapLoadedListener = new MapLoadedListener();

    @Nullable
    private FlutterMapView mapView;
    private MapViewOnTouchListener mapViewOnTouchListener;

    private ScaleBarController scaleBarController;
    private InvalidateMapHelper invalidateMapHelper;

    private Viewpoint viewpoint;

    private boolean haveScaleBar;

    private boolean trackViewpointChangedListenerEvents = false;

    private boolean trackTimeExtentEvents = false;

    private boolean disposed = false;

    private double minScale = 0;
    private double maxScale = 0;

    ArcgisMapController(
            int id,
            Context context,
            Map<String, Object> params,
            BinaryMessenger binaryMessenger,
            LifecycleProvider lifecycleProvider) {

        this.context = context;
        this.lifecycleProvider = lifecycleProvider;
        methodChannel = new MethodChannel(binaryMessenger, "plugins.flutter.io/arcgis_maps_" + id);
        methodChannel.setMethodCallHandler(this);

        mapView = new FlutterMapView(context);

        scaleBarController = new ScaleBarController(context, mapView, mapView);

        selectionPropertiesHandler = new SelectionPropertiesHandler(mapView.getSelectionProperties());

        symbolVisibilityFilterController = new SymbolVisibilityFilterController(mapView);

        layersController = new LayersController(methodChannel);
        mapChangeAwares.add(layersController);

        layersChangedController = new LayersChangedController(methodChannel);
        mapChangeAwares.add(layersChangedController);

        final GraphicsOverlay graphicsOverlay = new GraphicsOverlay();
        markersController = new MarkersController(context, methodChannel, graphicsOverlay);
        symbolControllers.add(markersController);

        polygonsController = new PolygonsController(methodChannel, graphicsOverlay);
        symbolControllers.add(polygonsController);

        polylinesController = new PolylinesController(methodChannel, graphicsOverlay);
        symbolControllers.add(polylinesController);

        final MethodChannel locationDisplayChannel = new MethodChannel(binaryMessenger, "plugins.flutter.io/arcgis_maps_" + id + "_location_display");
        locationDisplayController = new LocationDisplayController(locationDisplayChannel, mapView);
        locationDisplayController.setLocationDisplayControllerDelegate(this);

        initSymbolsControllers();


        mapViewOnTouchListener = new MapViewOnTouchListener(context, mapView, methodChannel);
        mapViewOnTouchListener.addGraphicDelegate(markersController);
        mapViewOnTouchListener.addGraphicDelegate(polygonsController);
        mapViewOnTouchListener.addGraphicDelegate(polylinesController);
        mapViewOnTouchListener.addGraphicDelegate(locationDisplayController);

        mapView.getGraphicsOverlays().add(graphicsOverlay);
        mapView.getMapView().setOnTouchListener(mapViewOnTouchListener);
        mapView.addViewpointChangedListener(this);

        invalidateMapHelper = new InvalidateMapHelper(mapView);

        lifecycleProvider.getLifecycle().addObserver(this);

        if (params == null) {
            return;
        }
        initWithParams(params);
        Log.d(TAG, "setApiKey: " + ArcGISRuntimeEnvironment.getApiKey());
    }


    @Override
    public View getView() {
        return mapView;
    }

    @Override
    public void dispose() {
        if (disposed) {
            return;
        }

        disposed = true;

        invalidateMapHelper.dispose();

        trackTimeExtentEvents = false;
        trackViewpointChangedListenerEvents = false;

        methodChannel.setMethodCallHandler(null);

        Lifecycle lifecycle = lifecycleProvider.getLifecycle();
        if (lifecycle != null) {
            lifecycle.removeObserver(this);
        }

        if (scaleBarController != null) {
            scaleBarController.dispose();
            scaleBarController = null;
        }

        mapViewOnTouchListener.clearAllDelegates();
        mapViewOnTouchListener = null;

        symbolVisibilityFilterController.clear();

        clearSymbolsControllers();
        clearMapAwareControllers();

        locationDisplayController.setLocationDisplayControllerDelegate(null);
        locationDisplayController.dispose();

        destroyMapViewIfNecessary();
    }

    @Override
    public void viewpointChanged(ViewpointChangedEvent viewpointChangedEvent) {
        if (trackViewpointChangedListenerEvents) {
            methodChannel.invokeMethod("map#viewpointChanged", null);
        }
    }


    @Override
    public void timeExtentChanged(TimeExtentChangedEvent timeExtentChangedEvent) {
        methodChannel.invokeMethod("map#timeExtentChanged", Convert.timeExtentToJson(timeExtentChangedEvent.getTimeExtent()));
    }

    @Override
    public void onUserLocationTap() {
        methodChannel.invokeMethod("map#onUserLocationTap", null);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if (disposed) {
            result.success(null);
            return;
        }
        switch (call.method) {
            case "map#waitForMap": {
                result.success(null);
            }
            break;
            case "map#update": {
                Map<?, ?> data = call.argument("options");
                if (data != null) {
                    updateMapOptions(data);
                }
                result.success(null);
            }
            break;
            case "map#exportImage": {
                ListenableFuture<Bitmap> future = mapView.exportImageAsync();
                future.addDoneListener(() -> {
                    try {
                        Bitmap bitmap = future.get();
                        result.success(Convert.bitmapToByteArray(bitmap));
                    } catch (Exception e) {
                        result.error("exportImage", e.getMessage(), null);
                    }
                });
            }
            break;
            case "map#getLegendInfos": {
                final LegendInfoController legendInfoController = new LegendInfoController(context, layersController);
                legendInfoControllers.add(legendInfoController);
                legendInfoController.loadAsync(call.arguments, results -> {
                    result.success(results);
                    legendInfoControllers.remove(legendInfoController);
                });
            }
            break;
            case "map#getMapMaxExtend": {
                if (mapView.getMap() != null) {
                    mapView.getMap().addDoneLoadingListener(() -> {
                        final Envelope maxExtend = mapView.getMap().getMaxExtent();
                        if (maxExtend == null) {
                            result.success(null);
                        } else {
                            result.success(Convert.geometryToJson(maxExtend));
                        }
                    });
                } else {
                    result.success(null);
                }
            }
            break;
            case "map#setMapMaxExtent": {
                final Envelope maxExtend = (Envelope) Convert.toGeometry(call.arguments);
                if (mapView.getMap() != null) {
                    mapView.getMap().setMaxExtent(maxExtend);
                }
                result.success(null);
            }
            break;
            case "map#setMap": {
                changeMapType(call.arguments);
                result.success(null);
            }
            break;
            case "map#setLayersChangedListener": {
                layersChangedController.setTrackLayersChange(call.arguments());
                result.success(null);
            }
            break;
            case "map#setTimeExtentChangedListener": {
                final boolean track = call.arguments();
                if (trackTimeExtentEvents != track) {
                    trackTimeExtentEvents = track;
                    if (trackTimeExtentEvents) {
                        mapView.addTimeExtentChangedListener(this);
                    } else {
                        mapView.removeTimeExtentChangedListener(this);
                    }
                }
                result.success(null);
            }
            break;
            case "map#setViewpointChangedListenerEvents": {
                trackViewpointChangedListenerEvents = call.arguments();
                result.success(null);
            }
            break;
            case "map#getTimeExtent": {
                result.success(Convert.timeExtentToJson(mapView.getTimeExtent()));
            }
            break;
            case "map#setTimeExtent": {
                mapView.setTimeExtent(Convert.toTimeExtent(call.arguments));
                result.success(null);
            }
            break;
            case "map#getMapRotation": {
                if (mapView.getMap() != null) {
                    result.success(mapView.getMapRotation());
                } else {
                    result.success(0.0);
                }
            }
            break;
            case "map#getWanderExtentFactor": {
                result.success(mapView.getLocationDisplay().getWanderExtentFactor());
            }
            break;
            case "map#getTimeAwareLayerInfos":
                handleTimeAwareLayerInfos(result);
                break;
            case "map#getCurrentViewpoint": {
                final Viewpoint currentViewPoint = mapView.getCurrentViewpoint(Convert.toViewpointType(call.arguments));
                if (currentViewPoint == null) {
                    result.success(null);
                } else {
                    result.success(Convert.viewpointToJson(currentViewPoint));
                }
            }
            break;
            case "map#setViewpoint": {
                setViewpoint(call.arguments, true, result);
            }
            break;
            case "map#setViewpointGeometry": {
                final Map<?, ?> data = call.arguments();
                final Geometry geometry = Convert.toGeometry(data.get("geometry"));
                final Object padding = data.get("padding");
                ListenableFuture<Boolean> future;
                if (padding == null) {
                    future = mapView.setViewpointGeometryAsync(geometry);
                } else {
                    final double paddingDouble = Convert.toDouble(padding);
                    future = mapView.setViewpointGeometryAsync(geometry, paddingDouble);
                }
                future.addDoneListener(() -> {
                    try {
                        result.success(future.get());
                    } catch (Exception e) {
                        Log.w(TAG, "map#setViewpointGeometry: ", e);
                        result.success(false);
                    }
                });
            }
            break;
            case "map#setViewpointCenter": {
                final Map<?, ?> data = call.arguments();
                final Point center = Convert.toPoint(data.get("center"));
                final double scale = Convert.toDouble(data.get("scale"));
                ListenableFuture<Boolean> future = mapView.setViewpointCenterAsync(center, scale);
                future.addDoneListener(() -> {
                    try {
                        result.success(future.get());
                    } catch (Exception e) {
                        Log.w(TAG, "map#setViewpointCenter: ", e);
                        result.success(false);
                    }
                });
            }
            break;
            case "map#setViewpointRotation": {
                final double angleDegrees = Convert.toDouble(call.arguments);
                mapView.setViewpointRotationAsync(angleDegrees).addDoneListener(() -> result.success(null));
            }
            break;
            case "map#locationToScreen": {
                final Point mapPoint = Convert.toPoint(call.arguments);
                final android.graphics.Point screenPoint = mapView.locationToScreen(mapPoint);
                if (screenPoint == null) {
                    result.success(null);
                } else {
                    double[] screenPoints = new double[2];
                    screenPoints[0] = Convert.pixelsToDpF(context, screenPoint.x);
                    screenPoints[1] = Convert.pixelsToDpF(context, screenPoint.y);
                    result.success(screenPoints);
                }
            }
            break;
            case "map#screenToLocation": {
                final ScreenLocationData screenLocationData = Convert.toScreenLocationData(context, call.arguments);
                Point mapPoint = mapView.screenToLocation(screenLocationData.getPoint());
                if (mapPoint == null) {
                    result.success(null);
                } else {
                    if (mapPoint.getSpatialReference().getWkid() != screenLocationData.getSpatialReference().getWkid()) {
                        mapPoint = (Point) GeometryEngine.project(mapPoint, screenLocationData.getSpatialReference());
                    }
                    result.success(Convert.geometryToJson(mapPoint));
                }
            }
            break;
            case "map#getMapScale": {
                if (mapView.getMap() != null) {
                    result.success(mapView.getMapScale());
                } else {
                    result.success(0.0);
                }
            }
            break;
            case "layers#update": {
                invalidateMapHelper.invalidateMapIfNeeded();
                layersController.updateFromArgs(call.arguments);
                result.success(null);
            }
            break;
            case "markers#update": {
                List<Object> markersToAdd = call.argument("markersToAdd");
                markersController.addMarkers(markersToAdd);
                List<Object> markersToChange = call.argument("markersToChange");
                markersController.changeMarkers(markersToChange);
                List<Object> markerIdsToRemove = call.argument("markerIdsToRemove");
                markersController.removeMarkers(markerIdsToRemove);
                invalidateMapHelper.invalidateMapIfNeeded();
                symbolVisibilityFilterController.invalidate();
                result.success(null);
            }
            break;
            case "map#clearMarkerSelection": {
                invalidateMapHelper.invalidateMapIfNeeded();
                selectionPropertiesHandler.reset();
                markersController.clearSelectedMarker();
                result.success(null);
            }
            break;
            case "polygons#update": {
                invalidateMapHelper.invalidateMapIfNeeded();
                List<Object> polygonsToAdd = call.argument("polygonsToAdd");
                polygonsController.addPolygons(polygonsToAdd);
                List<Object> polygonsToChange = call.argument("polygonsToChange");
                polygonsController.changePolygons(polygonsToChange);
                List<Object> polygonIdsToRemove = call.argument("polygonIdsToRemove");
                polygonsController.removePolygons(polygonIdsToRemove);
                result.success(null);
            }
            break;
            case "polylines#update": {
                invalidateMapHelper.invalidateMapIfNeeded();
                List<Object> polylinesToAdd = call.argument("polylinesToAdd");
                polylinesController.addPolylines(polylinesToAdd);
                List<Object> polylinesToChange = call.argument("polylinesToChange");
                polylinesController.changePolylines(polylinesToChange);
                List<Object> polylineIdsToRemove = call.argument("polylineIdsToRemove");
                polylinesController.removePolylines(polylineIdsToRemove);
                result.success(null);
            }
            break;
            case "layer#setTimeOffset": {
                layersController.setTimeOffset(call.arguments);
                result.success(null);
                break;
            }
            case "map#setViewpointScaleAsync": {
                final Map<?, ?> data = call.arguments();
                if (mapView != null && data != null) {
                    double scale = (double) data.get("scale");
                    ListenableFuture<Boolean> future = mapView.setViewpointScaleAsync(scale);
                    future.addDoneListener(() -> {
                        boolean scaled;
                        try {
                            scaled = future.get();
                            result.success(scaled);
                        } catch (ExecutionException | InterruptedException e) {
                            result.success(false);
                        }
                    });
                } else {
                    result.success(false);
                }
                break;
            }
            case "map#getInitialViewpoint": {
                if (mapView == null) {
                    result.success(null);
                    return;
                }
                ArcGISMap arcMap = mapView.getMap();
                if (arcMap == null) {
                    result.success(null);
                    return;
                }

                Viewpoint initialViewPoint = arcMap.getInitialViewpoint();

                if (initialViewPoint == null) {
                    result.success(null);
                } else {
                    result.success(Convert.viewpointToJson(initialViewPoint));
                }
                break;
            }
            default:
                result.notImplemented();
                break;
        }
    }

    @Override
    public void onCreate(@NonNull LifecycleOwner owner) {
        if (disposed) {
            return;
        }
    }

    @Override
    public void onStart(@NonNull LifecycleOwner owner) {
        if (disposed) {
            return;
        }
    }

    @Override
    public void onResume(@NonNull LifecycleOwner owner) {
        if (disposed) {
            return;
        }
        mapView.resume();
    }

    @Override
    public void onPause(@NonNull LifecycleOwner owner) {
        if (disposed) {
            return;
        }
        mapView.pause();
    }

    @Override
    public void onStop(@NonNull LifecycleOwner owner) {
        if (disposed) {
            return;
        }
    }

    @Override
    public void onDestroy(@NonNull LifecycleOwner owner) {
        owner.getLifecycle().removeObserver(this);
        if (disposed) {
            return;
        }
        destroyMapViewIfNecessary();
    }

    private void destroyMapViewIfNecessary() {
        if (mapView != null) {
            mapView.dispose();
            mapView.removeAllViews();
            mapView = null;
        }
        mapLoadedListener.setMap(null);
    }


    private void handleTimeAwareLayerInfos(MethodChannel.Result result) {
        final ArcGISMap map = mapView.getMap();
        if (map == null || map.getOperationalLayers().size() == 0) {
            result.success(new ArrayList<>());
            return;
        }

        final LayerList layers = map.getOperationalLayers();

        AGSLoadObjects.load(layers, (loaded -> {
            if (!loaded) {
                result.success(new ArrayList<>());
                return;
            }

            final ArrayList<Object> results = new ArrayList<>();

            for (final Layer layer : layers) {
                if (layer instanceof TimeAware) {
                    results.add(Convert.timeAwareToJson((TimeAware) layer, layersController.getLayerIdByLayer(layer)));
                }
            }
            result.success(results);
        }));
    }

    private void initSymbolsControllers() {
        for (final SymbolsController controller :
                symbolControllers) {
            controller.setSymbolVisibilityFilterController(symbolVisibilityFilterController);
            controller.setSelectionPropertiesHandler(selectionPropertiesHandler);
        }
    }

    private void clearSymbolsControllers() {
        for (final SymbolsController controller :
                symbolControllers) {
            controller.setSymbolVisibilityFilterController(null);
            controller.setSelectionPropertiesHandler(null);
        }
    }

    private void clearMapAwareControllers() {
        for (final MapChangeAware mapChangeAware :
                mapChangeAwares) {
            mapChangeAware.onMapChange(null);
        }
    }

    private void setViewpoint(Object args, boolean animated, @Nullable MethodChannel.Result result) {
        if (args == null) {
            if (result != null) {
                result.success(null);
            }
            return;
        }
        viewpoint = Convert.toViewPoint(args);

        if (mapView.getMap() == null) {
            if (result != null) {
                result.success(null);
            }
            return;
        }


        if (animated) {
            mapView.setViewpointAsync(viewpoint).addDoneListener(() -> {
                if (result != null) {
                    result.success(null);
                }
            });
        } else {
            mapView.setViewpointAsync(viewpoint, 0).addDoneListener(() -> {
                if (result != null) {
                    result.success(null);
                }
            });
        }

        viewpoint = null;
    }

    private void changeMapType(Object args) {
        if (args == null) {
            return;
        }
        final Map<?, ?> data = Convert.toMap(args);

        if (data.containsKey("offlinePath")) {
            loadOfflineMap(data);
            return;
        }

        final ArcGISMap map = Convert.toArcGISMap(args);
        changeMap(map);
    }

    private void loadOfflineMap(Map<?, ?> data) {
        final String offlinePath = (String) data.get("offlinePath");
        final int mapIndex = (int) data.get("offlineMapIndex");

        final String[] parts = offlinePath.split("\\.");
        final String ext = parts[parts.length - 1];

        switch (ext) {
            case "vtpk":
                final ArcGISVectorTiledLayer baseLayer = new ArcGISVectorTiledLayer(offlinePath);
                final Basemap baseMap = new Basemap(baseLayer);
                final ArcGISMap vMap = new ArcGISMap();
                vMap.setBasemap(baseMap);
                changeMap(vMap);
                break;
            // For offline maps we use the folder not the extension
            case "mmpk":
            default:
                final MobileMapPackage mobileMapPackage = new MobileMapPackage(offlinePath.replace(".mmpk", ""));
                mobileMapPackage.addDoneLoadingListener(() -> {
                    if (mobileMapPackage.getLoadStatus() == LoadStatus.LOADED) {
                        final ArcGISMap map = mobileMapPackage.getMaps().get(mapIndex);
                        changeMap(map);
                    } else {
                        Log.w(TAG, "loadOfflineMap: Failed to load map." + mobileMapPackage.getLoadError().getMessage());
                        if (mobileMapPackage.getLoadError().getCause() != null) {
                            Log.w(TAG, "loadOfflineMap: Failed to load map." + mobileMapPackage.getLoadError().getCause().getMessage());
                            methodChannel.invokeMethod("map#loaded", mobileMapPackage.getLoadError().getCause().getMessage());
                        } else {
                            methodChannel.invokeMethod("map#loaded", mobileMapPackage.getLoadError().getMessage());
                        }
                    }
                });
                mobileMapPackage.loadAsync();
                break;
        }
    }

    private void changeMap(ArcGISMap map) {
        Viewpoint viewpoint = this.viewpoint;
        if (viewpoint == null) {
            viewpoint = mapView.getCurrentViewpoint(Viewpoint.Type.CENTER_AND_SCALE);
        }
        mapLoadedListener.setMap(map);
        map.loadAsync();
        mapView.setMap(map);
        updateMapScale();

        for (final MapChangeAware mapChangeAware :
                mapChangeAwares) {
            mapChangeAware.onMapChange(map);
        }

        if (viewpoint != null) {
            this.viewpoint = null;
            ListenableFuture<Boolean> future = mapView.setViewpointAsync(viewpoint);
            future.addDoneListener(() -> invalidateMapHelper.invalidateMapIfNeeded());
        }
    }

    private void updateMapOptions(Object args) {
        if (args == null) {
            return;
        }
        final Map<?, ?> data = (Map<?, ?>) args;
        if (mapView != null) {
            Convert.interpretMapViewOptions(data, mapView);
        }

        final Object trackUserLocationTap = data.get("trackUserLocationTap");
        if (trackUserLocationTap != null) {
            locationDisplayController.setTrackUserLocationTap(Convert.toBoolean(trackUserLocationTap));
        }

        final Object trackIdentifyLayers = data.get("trackIdentifyLayers");
        if (trackIdentifyLayers != null) {
            mapViewOnTouchListener.setTrackIdentityLayers(Convert.toBoolean(trackIdentifyLayers));
        }

        final Object haveScaleBar = data.get("haveScalebar");

        if (haveScaleBar != null) {
            this.haveScaleBar = Convert.toBoolean(haveScaleBar);
        }

        final Object isAttributionTextVisible = data.get("isAttributionTextVisible");
        if (isAttributionTextVisible != null && mapView != null) {
            mapView.setAttributionTextVisible(Convert.toBoolean(isAttributionTextVisible));
        }

        final Object contentInsets = data.get("contentInsets");
        if (contentInsets != null && mapView != null) {
            // order is left,top,right,bottom
            final List<?> rect = Convert.toList(contentInsets);
            mapView.setViewInsets(Convert.toDouble(rect.get(0)), Convert.toDouble(rect.get(1)), Convert.toDouble(rect.get(2)), Convert.toDouble(rect.get(3)));
        }

        final Object scaleBarConfiguration = data.get("scalebarConfiguration");
        if (scaleBarConfiguration != null) {
            scaleBarController.interpretConfiguration(scaleBarConfiguration);
        } else if (!this.haveScaleBar) {
            scaleBarController.removeScaleBar();
        }

        final Object minScale = data.get("minScale");
        if (minScale != null) {
            this.minScale = Convert.toDouble(minScale);
        }

        final Object maxScale = data.get("maxScale");
        if (maxScale != null) {
            this.maxScale = Convert.toDouble(maxScale);
        }
        updateMapScale();
    }


    private void initWithParams(Map<String, Object> params) {
        final Object mapType = params.get("map");
        if (mapType != null) {
            changeMapType(mapType);
        }
        final Object viewPoint = params.get("viewpoint");
        if (viewPoint != null) {
            setViewpoint(viewPoint, false, null);
        }

        final Object options = params.get("options");
        if (options != null) {
            updateMapOptions(options);
        }

        layersController.updateFromArgs(params);

        final Object markersToAdd = params.get("markersToAdd");
        if (markersToAdd != null) {
            markersController.addMarkers((List<Object>) markersToAdd);
        }

        final Object polygonsToAdd = params.get("polygonsToAdd");
        if (polygonsToAdd != null) {
            polygonsController.addPolygons((List<Object>) polygonsToAdd);
        }

        final Object polylinesToAdd = params.get("polylinesToAdd");
        if (polylinesToAdd != null) {
            polylinesController.addPolylines((List<Object>) polylinesToAdd);
        }
    }


    private void updateMapScale() {
        if (mapView != null && mapView.getMap() != null) {
            mapView.getMap().setMinScale(minScale);
            mapView.getMap().setMaxScale(maxScale);
        }
    }

    private class MapLoadedListener implements Runnable {
        private ArcGISMap map;

        private MapLoadedListener() {

        }

        public void setMap(ArcGISMap map) {
            try {
                if (this.map != null) {
                    this.map.removeDoneLoadingListener(this);
                }
                this.map = map;
                if (map != null) {
                    map.addDoneLoadingListener(this);
                }
            } catch (Exception e) {
                Log.e(TAG, "setMap: ", e);
            }
        }

        @Override
        public void run() {
            if (disposed) {
                return;
            }
            map.removeDoneLoadingListener(this);
            if (map.getLoadStatus() == LoadStatus.LOADED) {
                methodChannel.invokeMethod("map#loaded", null);
            } else if (map.getLoadError() != null) {
                Log.w(TAG, "changeMap: Failed to load map." + map.getLoadError().getMessage());
                if (map.getLoadError().getCause() != null) {
                    Log.w(TAG, "changeMap: Failed to load map." + map.getLoadError().getCause().getMessage());
                }
                methodChannel.invokeMethod("map#loaded", Convert.arcGISRuntimeExceptionToJson(map.getLoadError()));
            } else {
                Log.w(TAG, "changeMap: Unknown error");
                methodChannel.invokeMethod("map#loaded", null);
            }
        }
    }

}
