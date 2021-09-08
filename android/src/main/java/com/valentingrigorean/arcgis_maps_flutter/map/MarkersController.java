package com.valentingrigorean.arcgis_maps_flutter.map;

import android.content.Context;

import com.esri.arcgisruntime.mapping.view.Graphic;
import com.esri.arcgisruntime.mapping.view.GraphicsOverlay;
import com.valentingrigorean.arcgis_maps_flutter.Convert;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;

public class MarkersController extends BaseSymbolController implements MapTouchGraphicDelegate {

    private final Map<String, MarkerController> markerIdToController = new HashMap<>();

    private final SymbolVisibilityFilterController symbolVisibilityFilterController;

    private final Context context;
    private final MethodChannel methodChannel;
    private final GraphicsOverlay graphicsOverlay;
    private final SelectionPropertiesHandler selectionPropertiesHandler;

    private MarkerController selectedMarker;


    public MarkersController(Context context, MethodChannel methodChannel, GraphicsOverlay graphicsOverlay, SelectionPropertiesHandler selectionPropertiesHandler, SymbolVisibilityFilterController symbolVisibilityFilterController) {
        this.context = context;
        this.methodChannel = methodChannel;
        this.graphicsOverlay = graphicsOverlay;
        this.selectionPropertiesHandler = selectionPropertiesHandler;
        this.symbolVisibilityFilterController = symbolVisibilityFilterController;
    }

    @Override
    public boolean canConsumeTaps() {
        for (final MarkerController controller : markerIdToController.values()) {
            if (controller.canConsumeTapEvents()) {
                return true;
            }
        }
        return false;
    }

    @Override
    public boolean didHandleGraphic(Graphic graphic) {
        final Object rawMarkerId = graphic.getAttributes().get("markerId");
        if (rawMarkerId == null) {
            return false;
        }
        final String markerId = (String) rawMarkerId;
        final MarkerController markerController = markerIdToController.get(markerId);
        if (markerController == null || !markerController.canConsumeTapEvents()) {
            return false;
        }
        if (selectedMarker != null)
            selectedMarker.setSelected(false);
        markerController.setSelected(true);
        selectedMarker = markerController;
        symbolVisibilityFilterController.invalidate(selectedMarker);
        methodChannel.invokeMethod("marker#onTap", Convert.markerIdToJson(markerId));
        return true;
    }

    public void addMarkers(List<Object> markersToAdd) {
        if (markersToAdd == null) {
            return;
        }
        executor.execute(() -> {
            for (Object marker : markersToAdd) {
                final Map<?, ?> data = (Map<?, ?>) marker;
                if (data == null) {
                    continue;
                }
                final String markerId = (String) data.get("markerId");
                final MarkerController markerController = new MarkerController(context, markerId, selectionPropertiesHandler);
                markerIdToController.put(markerId, markerController);
                Convert.interpretMarkerController(data, markerController, symbolVisibilityFilterController);

                addOrRemoveVisibilityFilter(symbolVisibilityFilterController, markerController, data);

                markerController.add(graphicsOverlay);
            }
        });
    }

    public void changeMarkers(List<Object> markersToChange) {
        if (markersToChange == null) {
            return;
        }
        executor.execute(() -> {
            for (Object marker : markersToChange) {
                final Map<?, ?> data = (Map<?, ?>) marker;
                if (data == null) {
                    continue;
                }
                final String markerId = (String) data.get("markerId");
                final MarkerController markerController = markerIdToController.get(markerId);
                if (markerController != null) {
                    Convert.interpretMarkerController(data, markerController, symbolVisibilityFilterController);
                    addOrRemoveVisibilityFilter(symbolVisibilityFilterController, markerController, data);
                }
            }
        });

    }

    public void removeMarkers(List<Object> markerIdsToRemove) {
        if (markerIdsToRemove == null) {
            return;
        }
        executor.execute(() -> {
            for (Object rawMarkerId : markerIdsToRemove) {
                if (rawMarkerId == null) {
                    continue;
                }
                final String markerId = (String) rawMarkerId;
                final MarkerController markerController = markerIdToController.remove(markerId);
                if (markerController != null) {
                    symbolVisibilityFilterController.removeGraphicsController(markerController);
                    markerController.remove(graphicsOverlay);
                }
            }
        });
    }

    public void clearSelectedMarker() {
        if (selectedMarker == null) {
            return;
        }
        selectedMarker.setSelected(false);
        symbolVisibilityFilterController.invalidate(selectedMarker);
        selectedMarker = null;
    }
}
