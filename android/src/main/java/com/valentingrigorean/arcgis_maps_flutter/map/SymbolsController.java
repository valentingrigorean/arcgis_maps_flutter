package com.valentingrigorean.arcgis_maps_flutter.map;

public interface SymbolsController {
    SymbolVisibilityFilterController getSymbolVisibilityFilterController();

    void setSymbolVisibilityFilterController(SymbolVisibilityFilterController symbolVisibilityFilterController);

    SelectionPropertiesHandler getSelectionPropertiesHandler();

    void setSelectionPropertiesHandler(SelectionPropertiesHandler selectionPropertiesHandler);
}
