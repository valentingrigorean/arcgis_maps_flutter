package com.valentingrigorean.arcgis_maps_flutter.map;

import com.esri.arcgisruntime.mapping.view.Graphic;
import com.esri.arcgisruntime.mapping.view.GraphicsOverlay;
import com.valentingrigorean.arcgis_maps_flutter.Convert;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;

public class PolylinesController extends BaseSymbolController implements MapTouchGraphicDelegate {
    final Map<String, PolylineController> polylineIdToController = new HashMap<>();

    private final MethodChannel methodChannel;
    private final GraphicsOverlay graphicsOverlay;


    public PolylinesController(MethodChannel methodChannel, GraphicsOverlay graphicsOverlay) {
        this.methodChannel = methodChannel;
        this.graphicsOverlay = graphicsOverlay;
    }

    @Override
    public boolean canConsumeTaps() {
        for (final PolylineController controller : polylineIdToController.values()) {
            if (controller.canConsumeTapEvents()) {
                return true;
            }
        }
        return false;
    }

    @Override
    public boolean didHandleGraphic(Graphic graphic) {
        final Object rawPolylineId = graphic.getAttributes().get("polylineId");
        if (rawPolylineId == null) {
            return false;
        }
        final String polylineId = (String) rawPolylineId;
        final PolylineController controller = polylineIdToController.get(polylineId);
        if (controller == null || !controller.canConsumeTapEvents()) {
            return false;
        }
        methodChannel.invokeMethod("polyline#onTap", Convert.polylineIdToJson(polylineId));
        return true;
    }

    public void addPolylines(List<Object> polylinesToAdd) {
        if (polylinesToAdd == null) {
            return;
        }

        execute(() -> {
            for (Object polyline : polylinesToAdd) {
                final Map<?, ?> data = (Map<?, ?>) polyline;
                if (data == null) {
                    continue;
                }
                final String polylineId = (String) data.get("polylineId");
                final PolylineController controller = new PolylineController(polylineId);
                controller.setSelectionPropertiesHandler(getSelectionPropertiesHandler());
                polylineIdToController.put(polylineId, controller);
                Convert.interpretPolylineController(data, controller, getSymbolVisibilityFilterController());
                controller.add(graphicsOverlay);
            }
        });
    }

    public void changePolylines(List<Object> polylinesToChange) {
        if (polylinesToChange == null) {
            return;
        }

        execute(() -> {
            for (Object polyline : polylinesToChange) {
                final Map<?, ?> data = (Map<?, ?>) polyline;
                if (data == null) {
                    continue;
                }
                final String polylineId = (String) data.get("polylineId");
                final PolylineController controller = polylineIdToController.get(polylineId);
                if (controller != null) {
                    Convert.interpretPolylineController(data, controller, getSymbolVisibilityFilterController());
                }
            }
        });
    }

    public void removePolylines(List<Object> polylineIdsToRemove) {
        if (polylineIdsToRemove == null) {
            return;
        }

        execute(() -> {
            for (Object rawPolylineId : polylineIdsToRemove) {
                if (rawPolylineId == null) {
                    continue;
                }
                final String polylineId = (String) rawPolylineId;
                final PolylineController controller = polylineIdToController.remove(polylineId);
                if (controller != null) {
                    onSymbolRemoval(controller);
                    controller.remove(graphicsOverlay);
                }
            }
        });
    }
}
