package com.valentingrigorean.arcgis_maps_flutter.map;

import com.esri.arcgisruntime.mapping.view.Graphic;
import com.esri.arcgisruntime.mapping.view.GraphicsOverlay;
import com.valentingrigorean.arcgis_maps_flutter.Convert;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;

public class PolygonsController extends BaseSymbolController implements MapTouchGraphicDelegate {
    private final Map<String, PolygonController> polygonIdToController = new HashMap<>();

    private final MethodChannel methodChannel;
    private final GraphicsOverlay graphicsOverlay;
    private final SelectionPropertiesHandler selectionPropertiesHandler;


    public PolygonsController(MethodChannel methodChannel, GraphicsOverlay graphicsOverlay, SelectionPropertiesHandler selectionPropertiesHandler) {
        this.methodChannel = methodChannel;
        this.graphicsOverlay = graphicsOverlay;
        this.selectionPropertiesHandler = selectionPropertiesHandler;
    }

    @Override
    public boolean canConsumeTaps() {
        for (final PolygonController controller : polygonIdToController.values()) {
            if (controller.canConsumeTapEvents()) {
                return true;
            }
        }
        return false;
    }

    @Override
    public boolean didHandleGraphic(Graphic graphic) {
        final Object rawPolygonId = graphic.getAttributes().get("polygonId");
        if (rawPolygonId == null) {
            return false;
        }
        final String polygonId = (String) rawPolygonId;
        final PolygonController controller = polygonIdToController.get(polygonId);
        if (controller == null || !controller.canConsumeTapEvents()) {
            return false;
        }
        methodChannel.invokeMethod("polygon#onTap", Convert.polygonIdToJson(polygonId));
        return true;
    }

    public void addPolygons(List<Object> polygonsToAdd) {
        if (polygonsToAdd == null) {
            return;
        }

        executor.execute(() -> {
            for (Object polygon : polygonsToAdd) {
                final Map<?, ?> data = (Map<?, ?>) polygon;
                if (data == null) {
                    continue;
                }
                final String polygonId = (String) data.get("polygonId");
                final PolygonController controller = new PolygonController(polygonId, selectionPropertiesHandler);
                polygonIdToController.put(polygonId, controller);
                Convert.interpretPolygonController(data, controller);
                controller.add(graphicsOverlay);
            }
        });
    }

    public void changePolygons(List<Object> polygonsToChange) {
        if (polygonsToChange == null) {
            return;
        }
        executor.execute(() -> {
            for (Object polygon : polygonsToChange) {
                final Map<?, ?> data = (Map<?, ?>) polygon;
                if (data == null) {
                    continue;
                }
                final String polygonId = (String) data.get("polygonId");
                final PolygonController controller = polygonIdToController.get(polygonId);
                if (controller == null) {
                    continue;
                }
                Convert.interpretPolygonController(data, controller);
            }
        });
    }

    public void removePolygons(List<Object> polygonIdsToRemove) {
        if (polygonIdsToRemove == null) {
            return;
        }
        executor.execute(() -> {
            for (Object rawPolygonId : polygonIdsToRemove) {
                if (rawPolygonId == null) {
                    continue;
                }
                final String polygonId = (String) rawPolygonId;
                final PolygonController controller = polygonIdToController.remove(polygonId);
                if (controller != null) {
                    controller.remove(graphicsOverlay);
                }
            }
        });
    }
}
