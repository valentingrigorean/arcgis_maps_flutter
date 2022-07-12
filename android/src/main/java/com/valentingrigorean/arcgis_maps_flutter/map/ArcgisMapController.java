package com.valentingrigorean.arcgis_maps_flutter.map;

import android.content.Context;
import android.graphics.Color;
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
import com.esri.arcgisruntime.geometry.Geometry;
import com.esri.arcgisruntime.geometry.GeometryEngine;
import com.esri.arcgisruntime.geometry.Point;
import com.esri.arcgisruntime.layers.Layer;
import com.esri.arcgisruntime.location.LocationDataSource;
import com.esri.arcgisruntime.mapping.ArcGISMap;
import com.esri.arcgisruntime.mapping.LayerList;
import com.esri.arcgisruntime.mapping.Viewpoint;
import com.esri.arcgisruntime.mapping.view.BackgroundGrid;
import com.esri.arcgisruntime.mapping.view.GraphicsOverlay;
import com.esri.arcgisruntime.mapping.view.LocationDisplay;
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


    private final int id;
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

    @Nullable
    private MapView mapView;
    private MapViewOnTouchListener mapViewOnTouchListener;

    private FrameLayout mapContainer;
    private Viewpoint viewpoint;
    private ScaleBarController scaleBarController;

    private boolean haveScaleBar;

    private boolean trackViewpointChangedListenerEvents = false;

    private boolean trackTimeExtentEvents = false;

    private boolean disposed = false;

    ArcgisMapController(
            int id,
            Context context,
            Map<String, Object> params,
            BinaryMessenger binaryMessenger,
            LifecycleProvider lifecycleProvider) {

        this.id = id;

        this.context = context;
        this.lifecycleProvider = lifecycleProvider;
        methodChannel = new MethodChannel(binaryMessenger, "plugins.flutter.io/arcgis_maps_" + id);
        methodChannel.setMethodCallHandler(this);

        mapContainer = new FrameLayout(context);

        mapView = new MapView(context);
        //added by Jarvanmo
        mapView.setBackgroundGrid(new BackgroundGrid(0xFFF5F5F5, 0xFFF5F5F5, 0F, 10F));
        mapView.getSelectionProperties().setColor(Color.BLACK);

        mapContainer.addView(mapView, new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT));

        scaleBarController = new ScaleBarController(context, mapView, mapContainer);

        selectionPropertiesHandler = new SelectionPropertiesHandler(mapView.getSelectionProperties());

        symbolVisibilityFilterController = new SymbolVisibilityFilterController(mapView);

        layersController = new LayersController(methodChannel);
        mapChangeAwares.add(layersController);

        layersChangedController = new LayersChangedController(methodChannel, layersController);
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
        mapView.setOnTouchListener(mapViewOnTouchListener);
        mapView.addViewpointChangedListener(this);


        lifecycleProvider.getLifecycle().addObserver(this);

        if (params == null) {
            return;
        }
        initWithParams(params);
        Log.d(TAG, "setApiKey: " + ArcGISRuntimeEnvironment.getApiKey());
    }


    @Override
    public View getView() {
        return mapContainer;
    }

    @Override
    public void dispose() {
        if (disposed) {
            return;
        }

        disposed = true;

        trackTimeExtentEvents = false;
        trackViewpointChangedListenerEvents = false;

        methodChannel.setMethodCallHandler(null);

        Lifecycle lifecycle = lifecycleProvider.getLifecycle();
        if (lifecycle != null) {
            lifecycle.removeObserver(this);
        }


        if (mapView != null) {
            mapView.removeTimeExtentChangedListener(this);
            mapView.removeViewpointChangedListener(this);
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

        if (mapContainer != null) {
            destroyMapViewIfNecessary();
        }
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
            case "map#getLegendInfos": {
                final LegendInfoController legendInfoController = new LegendInfoController(context, layersController);
                legendInfoControllers.add(legendInfoController);
                legendInfoController.loadAsync(call.arguments, results -> {
                    result.success(results);
                    legendInfoControllers.remove(legendInfoController);
                });
            }
            break;
            case "map#setMap": {
                final Viewpoint viewpoint = mapView.getCurrentViewpoint(Viewpoint.Type.CENTER_AND_SCALE);
                changeMapType(call.arguments);
                if (viewpoint != null) {
                    mapView.setViewpointAsync(viewpoint, 0);
                }
                result.success(null);
            }
            break;
            case "map#setViewpointChangedEvents": {
                trackViewpointChangedListenerEvents = call.arguments();
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
                result.success(mapView.getMapRotation());
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
                viewpoint = Convert.toViewPoint(call.arguments);
                mapView.setViewpointAsync(viewpoint).addDoneListener(() -> result.success(null));
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
                double[] screenPoints = new double[2];
                screenPoints[0] = Convert.pixelsToDpF(context, screenPoint.x);
                screenPoints[1] = Convert.pixelsToDpF(context, screenPoint.y);
                result.success(screenPoints);
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
                result.success(mapView.getMapScale());
            }
            break;
            case "layers#update": {
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
                result.success(null);
            }
            break;
            case "map#clearMarkerSelection": {
                selectionPropertiesHandler.reset();
                markersController.clearSelectedMarker();
                result.success(null);
            }
            break;
            case "polygons#update": {
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
            case "map#setInitialViewpoint": {
                //added by Jarvanmo
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
                if (initialViewPoint != null) {
                    mapView.setViewpointAsync(initialViewPoint).addDoneListener(() -> result.success(null));
                } else {
                    mapView.setViewpointAsync(mapView.getCurrentViewpoint(Viewpoint.Type.BOUNDING_GEOMETRY)).addDoneListener(() -> result.success(null));
                }
            }
            break;
            case "map#recenter": {
                //added by Jarvanmo
                if (mapView == null) {
                    result.success(null);
                    return;
                }
                LocationDisplay locationDisplay = mapView.getLocationDisplay();
                if (!locationDisplay.isStarted()) {
                    locationDisplay.setAutoPanMode(LocationDisplay.AutoPanMode.RECENTER);
                    locationDisplay.startAsync();
                    result.success(null);
                } else {
                    result.success(null);
                }
            }
            break;
            case "map#setViewpointScaleAsync": {
                final Map<?, ?> data = call.arguments();
                if (mapView != null && data != null) {
                    double scale = (double) data.get("scale");
                    ListenableFuture<Boolean> future = mapView.setViewpointScaleAsync(scale);
                    future.addDoneListener(() -> {
                        boolean scaled = false;
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
            case "map#setViewpointScaleAsync": {
                final Map<?, ?> data = call.arguments();
                if (mapView != null && data != null) {
                    double scale = (double) data.get("scale");
                    ListenableFuture<Boolean> future = mapView.setViewpointScaleAsync(scale);
                    future.addDoneListener(() -> {
                        boolean scaled = false;
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
        if (mapContainer != null) {
            mapContainer.removeAllViews();
            mapContainer = null;
        }
        if (mapView != null) {
            mapView.dispose();
            mapView = null;
        }
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

    private void setViewpoint(Object args, boolean animated) {
        if (args == null) {
            return;
        }
        final Viewpoint viewpoint = Convert.toViewPoint(args);

        if (animated) {
            mapView.setViewpoint(viewpoint);
        } else {
            mapView.setViewpointAsync(viewpoint);
        }
    }

    private void changeMapType(Object args) {
        if (args == null) {
            return;
        }
        final ArcGISMap map = Convert.toArcGISMap(args);
        map.addDoneLoadingListener(() -> {
            methodChannel.invokeMethod("map#loaded", null);
        });
        mapView.setMap(map);
        for (final MapChangeAware mapChangeAware :
                mapChangeAwares) {
            mapChangeAware.onMapChange(map);
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
    }


    private void initWithParams(Map<String, Object> params) {
        final Object mapType = params.get("map");
        if (mapType != null) {
            changeMapType(mapType);
        }
        final Object viewPoint = params.get("viewpoint");
        if (viewPoint != null) {
            setViewpoint(viewPoint, false);
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
}
