package com.valentingrigorean.arcgis_maps_flutter.mapping.symbology

import android.graphics.Color
import com.valentingrigorean.arcgis_maps_flutter.Convert
import com.valentingrigorean.arcgis_maps_flutter.map.GraphicControllerSink
import com.valentingrigorean.arcgis_maps_flutter.map.SelectionPropertiesHandler
import com.valentingrigorean.arcgis_maps_flutter.map.SymbolVisibilityFilterController
import com.valentingrigorean.arcgis_maps_flutter.map.SymbolsController

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

    protected fun interpretGraphicController(
        data: Map<*, *>,
        controller: GraphicControllerSink,
    ) {
        val consumeTapEvents = data["consumeTapEvents"]
        if (consumeTapEvents != null) {
            controller.setConsumeTapEvents(Convert.toBoolean(consumeTapEvents))
        }
        val visible = data["visible"]
        if (visible != null) {
            val visibilityFilter = data["visibilityFilter"]
            if (symbolVisibilityFilterController != null && visibilityFilter != null) {
                symbolVisibilityFilterController!!.addGraphicsController(
                    controller,
                    Convert.toSymbolVisibilityFilter(visibilityFilter),
                    Convert.toBoolean(visible)
                )
            } else {
                controller.visible = Convert.toBoolean(visible)
            }
        }
        val zIndex = data["zIndex"]
        if (zIndex != null) {
            controller.setZIndex(Convert.toInt(zIndex))
        }
        val selectedColor = data["selectedColor"]
        if (selectedColor != null) {
            controller.setSelectedColor(Color.valueOf(Convert.toInt(selectedColor)))
        }
    }
}