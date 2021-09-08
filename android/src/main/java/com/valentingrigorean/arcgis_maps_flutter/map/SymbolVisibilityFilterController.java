package com.valentingrigorean.arcgis_maps_flutter.map;

import com.esri.arcgisruntime.mapping.view.MapScaleChangedEvent;
import com.esri.arcgisruntime.mapping.view.MapScaleChangedListener;
import com.esri.arcgisruntime.mapping.view.MapView;

import java.util.HashMap;
import java.util.Map;

public class SymbolVisibilityFilterController extends BaseSymbolWorkerController implements MapScaleChangedListener {
    private final Map<BaseGraphicController, SymbolVisibilityFilter> graphicControllers = new HashMap<>();
    private final Map<BaseGraphicController, Boolean> initialValues = new HashMap<>();
    private final MapView mapView;

    private boolean isRegister;

    public SymbolVisibilityFilterController(MapView mapView) {
        this.mapView = mapView;
    }

    public void clear() {
        mapView.removeMapScaleChangedListener(this);
        isRegister = false;

        executor.execute(() -> {
            for (Map.Entry<BaseGraphicController, SymbolVisibilityFilter> entry :
                    graphicControllers.entrySet()) {
                entry.getKey().setVisible(initialValues.remove(entry.getKey()));
            }
            graphicControllers.clear();
        });
    }

    public void addGraphicsController(BaseGraphicController graphicController, SymbolVisibilityFilter symbolVisibilityFilter, boolean initValue) {
        executor.execute(() -> {
            if (initialValues.containsKey(graphicController)) {
                initialValues.remove(graphicController);
            }

            initialValues.put(graphicController, initValue);

            handleGraphicsFilterZoom(graphicController, symbolVisibilityFilter, mapView.getMapScale());

            if (graphicControllers.containsKey(graphicController)) {
                if (graphicControllers.get(graphicController) == symbolVisibilityFilter) {
                    return;
                }
                graphicControllers.remove(graphicController);
            }

            graphicControllers.put(graphicController, symbolVisibilityFilter);
            handleRegistrationToScaleChanged();
        });
    }

    public void removeGraphicsController(BaseGraphicController graphicController) {
        executor.execute(() -> {
            if (!containsGraphicsController(graphicController)) {
                return;
            }
            graphicController.setVisible(initialValues.remove(graphicController));
            graphicControllers.remove(graphicController);
            handleRegistrationToScaleChanged();
        });
    }

    @Override
    public void mapScaleChanged(MapScaleChangedEvent mapScaleChangedEvent) {
        executor.execute(() -> {
            final double currentZoom = mapScaleChangedEvent.getSource().getMapScale();
            for (Map.Entry<BaseGraphicController, SymbolVisibilityFilter> entry :
                    graphicControllers.entrySet()) {
                handleGraphicsFilterZoom(entry.getKey(), entry.getValue(), currentZoom);
            }
        });
    }


    private boolean containsGraphicsController(BaseGraphicController graphicController) {
        return graphicControllers.containsKey(graphicController);
    }

    private void handleGraphicsFilterZoom(BaseGraphicController graphicController, SymbolVisibilityFilter visibilityFilter, double currentZoom) {
        if (Double.isNaN(currentZoom)) {
            return;
        }
        if (currentZoom < visibilityFilter.getMinZoom() && currentZoom > visibilityFilter.getMaxZoom()) {
            graphicController.setVisible(initialValues.get(graphicController));
        } else {
            if (!graphicController.isSelected()) {
                graphicController.setVisible(false);
            }
        }
    }

    private void handleRegistrationToScaleChanged() {
        if (graphicControllers.size() > 0 && !isRegister) {
            isRegister = true;
            mapView.addMapScaleChangedListener(this);
        } else if (graphicControllers.size() == 0 && isRegister) {
            isRegister = false;
            mapView.removeMapScaleChangedListener(this);
        }
    }
}
