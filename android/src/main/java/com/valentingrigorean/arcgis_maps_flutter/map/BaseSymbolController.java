package com.valentingrigorean.arcgis_maps_flutter.map;

public abstract class BaseSymbolController extends BaseSymbolWorkerController  implements SymbolsController{

    private SymbolVisibilityFilterController symbolVisibilityFilterController;
    private SelectionPropertiesHandler selectionPropertiesHandler;

    public SymbolVisibilityFilterController getSymbolVisibilityFilterController() {
        return symbolVisibilityFilterController;
    }

    public void setSymbolVisibilityFilterController(SymbolVisibilityFilterController symbolVisibilityFilterController) {
        this.symbolVisibilityFilterController = symbolVisibilityFilterController;
    }

    public SelectionPropertiesHandler getSelectionPropertiesHandler() {
        return selectionPropertiesHandler;
    }

    public void setSelectionPropertiesHandler(SelectionPropertiesHandler selectionPropertiesHandler) {
        this.selectionPropertiesHandler = selectionPropertiesHandler;
    }

    protected void onSymbolRemoval(GraphicControllerSink controller) {
        final SymbolVisibilityFilterController visibilityFilterController = getSymbolVisibilityFilterController();
        if (visibilityFilterController != null) {
            visibilityFilterController.removeGraphicsController(controller);
        }
    }

    protected void invalidateVisibilityFilterController(GraphicControllerSink controller) {
        final SymbolVisibilityFilterController filterController = getSymbolVisibilityFilterController();
        if (filterController != null) {
            filterController.invalidate(controller);
        }
    }
}
