package com.valentingrigorean.arcgis_maps_flutter.map

abstract class BaseSymbolController : SymbolsController {
    override var symbolVisibilityFilterController: SymbolVisibilityFilterController? = null
    override var selectionPropertiesHandler: SelectionPropertiesHandler? = null
    protected fun onSymbolRemoval(controller: GraphicControllerSink) {
        val visibilityFilterController = symbolVisibilityFilterController
        visibilityFilterController?.removeGraphicsController(controller)
    }

    protected fun invalidateVisibilityFilterController(controller: GraphicControllerSink) {
        val filterController = symbolVisibilityFilterController
        filterController?.invalidate(controller)
    }
}