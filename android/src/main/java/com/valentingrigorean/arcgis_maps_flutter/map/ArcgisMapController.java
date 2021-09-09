package com.valentingrigorean.arcgis_maps_flutter.map;

import android.content.Context;
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
import com.esri.arcgisruntime.geometry.GeometryEngine;
import com.esri.arcgisruntime.geometry.Point;
import com.esri.arcgisruntime.mapping.ArcGISMap;
import com.esri.arcgisruntime.mapping.Viewpoint;
import com.esri.arcgisruntime.mapping.view.GraphicsOverlay;
import com.esri.arcgisruntime.mapping.view.LocationDisplay;
import com.esri.arcgisruntime.mapping.view.MapView;
import com.esri.arcgisruntime.mapping.view.ViewpointChangedEvent;
import com.esri.arcgisruntime.mapping.view.ViewpointChangedListener;
import com.valentingrigorean.arcgis_maps_flutter.Convert;
import com.valentingrigorean.arcgis_maps_flutter.LifecycleProvider;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

final class ArcgisMapController implements DefaultLifecycleObserver, PlatformView, MethodChannel.MethodCallHandler, ViewpointChangedListener, LocationDisplay.AutoPanModeChangedListener {

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

    private final SymbolVisibilityFilterController symbolVisibilityFilterController;


    @Nullable
    private MapView mapView;
    private MapViewOnTouchListener mapViewOnTouchListener;

    private FrameLayout mapContainer;
    private Viewpoint viewpoint;
    private ScaleBarController scaleBarController;

    private boolean haveScaleBar;

    private boolean trackViewpointChangedListenerEvent = false;

    private boolean trackCameraPosition = false;

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

        mapContainer.addView(mapView, new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT));

        scaleBarController = new ScaleBarController(context, mapView, mapContainer);

        selectionPropertiesHandler = new SelectionPropertiesHandler(mapView.getSelectionProperties());

        symbolVisibilityFilterController = new SymbolVisibilityFilterController(mapView);

        final GraphicsOverlay graphicsOverlay = new GraphicsOverlay();
        layersController = new LayersController(methodChannel);

        markersController = new MarkersController(context, methodChannel, graphicsOverlay);
        symbolControllers.add(markersController);

        polygonsController = new PolygonsController(methodChannel, graphicsOverlay);
        symbolControllers.add(polygonsController);

        polylinesController = new PolylinesController(methodChannel, graphicsOverlay);
        symbolControllers.add(polylinesController);

        initSymbolsControllers();

        mapViewOnTouchListener = new MapViewOnTouchListener(context, mapView, methodChannel);
        mapViewOnTouchListener.addGraphicDelegate(markersController);
        mapViewOnTouchListener.addGraphicDelegate(polygonsController);
        mapViewOnTouchListener.addGraphicDelegate(polylinesController);

        mapView.getGraphicsOverlays().add(graphicsOverlay);
        mapView.setOnTouchListener(mapViewOnTouchListener);
        mapView.addViewpointChangedListener(this);
        mapView.getLocationDisplay().addAutoPanModeChangedListener(this);


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
        symbolVisibilityFilterController.clear();
        methodChannel.setMethodCallHandler(null);
        destroyMapViewIfNecessary();

        Lifecycle lifecycle = lifecycleProvider.getLifecycle();
        if (lifecycle != null) {
            lifecycle.removeObserver(this);
        }
    }

    @Override
    public void viewpointChanged(ViewpointChangedEvent viewpointChangedEvent) {
        if (trackViewpointChangedListenerEvent) {
            methodChannel.invokeMethod("map#viewpointChanged", null);
        }

        if (trackCameraPosition) {
            methodChannel.invokeMethod("camera#onMove", null);
        }
    }

    @Override
    public void onAutoPanModeChanged(LocationDisplay.AutoPanModeChangedEvent autoPanModeChangedEvent) {
        methodChannel.invokeMethod("map#autoPanModeChanged", autoPanModeChangedEvent.getAutoPanMode().ordinal());
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
                if (data != null)
                    updateMapOptions(data);
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
            case "map#setViewpointChangedListenerEvents": {
                trackViewpointChangedListenerEvent = Convert.toBoolean(call.arguments);
                result.success(null);
            }
            break;
            case "map#isLocationDisplayStarted": {
                result.success(mapView.getLocationDisplay().isStarted());
            }
            break;
            case "map#setLocationDisplay": {
                final Boolean started = Convert.toBoolean(call.arguments);
                if (started != mapView.getLocationDisplay().isStarted()) {
                    if (started) {
                        mapView.getLocationDisplay().startAsync();
                    } else {
                        mapView.getLocationDisplay().stop();
                    }
                }
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
            case "map#getCurrentViewpoint": {
                final Viewpoint currentViewPoint = mapView.getCurrentViewpoint(Convert.toViewpointType(call.arguments));
                final String json = currentViewPoint.toJson();
                result.success(json);
            }
            break;
            case "map#setViewpoint": {
                viewpoint = Convert.toViewPoint(call.arguments);
                mapView.setViewpointAsync(viewpoint).addDoneListener(() -> result.success(null));
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
                    result.success(mapPoint.toJson());
                }
            }
            break;
            case "map#getMapScale":
                result.success(mapView.getMapScale());
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

        if (scaleBarController != null) {
            scaleBarController.dispose();
            scaleBarController = null;
        }

        clearSymbolsControllers();

        if (mapView == null) {
            return;
        }
        mapViewOnTouchListener.clearAllDelegates();
        mapViewOnTouchListener = null;
        mapView.removeViewpointChangedListener(this);
        mapView.dispose();
        mapView = null;
    }

    private void initSymbolsControllers(){
        for (final SymbolsController controller :
                symbolControllers) {
            controller.setSymbolVisibilityFilterController(symbolVisibilityFilterController);
            controller.setSelectionPropertiesHandler(selectionPropertiesHandler);
        }
    }

    private void clearSymbolsControllers(){
        for (final SymbolsController controller :
                symbolControllers) {
            controller.setSymbolVisibilityFilterController(null);
            controller.setSelectionPropertiesHandler(null);
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
        layersController.setMap(map);
    }

    private void updateMapOptions(Object args) {
        if (args == null) {
            return;
        }
        final Map<?, ?> data = (Map<?, ?>) args;
        Convert.interpretMapViewOptions(data, mapView);

        final Object trackCameraPosition = data.get("trackCameraPosition");
        if (trackCameraPosition != null) {
            this.trackCameraPosition = Convert.toBoolean(trackCameraPosition);
        }

        final Object trackIdentifyLayers = data.get("trackIdentifyLayers");
        if (trackIdentifyLayers != null) {
            mapViewOnTouchListener.setTrackIdentityLayers(Convert.toBoolean(trackIdentifyLayers));
        }

        final Object haveScaleBar = data.get("haveScalebar");

        if (haveScaleBar != null) {
            this.haveScaleBar = Convert.toBoolean(haveScaleBar);
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
