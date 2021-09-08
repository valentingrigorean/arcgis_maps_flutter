package com.valentingrigorean.arcgis_maps_flutter.map;

import com.valentingrigorean.arcgis_maps_flutter.Convert;

import java.util.Map;

public abstract class BaseSymbolController extends BaseSymbolWorkerController {

    protected void addOrRemoveVisibilityFilter(SymbolVisibilityFilterController symbolVisibilityFilterController, BaseGraphicController graphicController, Map<?, ?> data) {
        final Object visibilityFilter = data.get("visibilityFilter");
        if (visibilityFilter != null) {
            symbolVisibilityFilterController.addGraphicsController(graphicController, Convert.toSymbolVisibilityFilter(visibilityFilter), graphicController.getVisible());
        } else {
            symbolVisibilityFilterController.removeGraphicsController(graphicController);
        }
    }
}
