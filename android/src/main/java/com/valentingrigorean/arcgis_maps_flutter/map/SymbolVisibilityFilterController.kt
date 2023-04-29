package com.valentingrigorean.arcgis_maps_flutter.map

import com.esri.arcgisruntime.mapping.view.MapScaleChangedEvent
import com.esri.arcgisruntime.mapping.view.MapScaleChangedListener

class SymbolVisibilityFilterController(private val flutterMapViewDelegate: FlutterMapViewDelegate) :
    MapScaleChangedListener {
    private val graphicControllers: MutableMap<GraphicControllerSink, SymbolVisibilityFilter?> =
        HashMap()
    private val initialValues: MutableMap<GraphicControllerSink, Boolean> = HashMap()
    private var isRegister = false
    fun clear() {
        flutterMapViewDelegate.removeMapScaleChangedListener(this)
        isRegister = false
        for ((key) in graphicControllers) {
            key.setVisible(initialValues.remove(key))
        }
        graphicControllers.clear()
    }

    fun containsGraphicsController(graphicController: GraphicControllerSink): Boolean {
        return graphicControllers.containsKey(graphicController)
    }

    fun updateInitialVisibility(graphicController: GraphicControllerSink, initValue: Boolean) {
        if (initialValues.containsKey(graphicController)) {
            initialValues.replace(graphicController, initValue)
        }
    }

    fun invalidate(graphicController: GraphicControllerSink) {
        if (containsGraphicsController(graphicController)) {
            handleGraphicsFilterZoom(
                graphicController,
                graphicControllers[graphicController],
                flutterMapViewDelegate.mapScale
            )
        }
    }

    fun addGraphicsController(
        graphicController: GraphicControllerSink,
        symbolVisibilityFilter: SymbolVisibilityFilter?,
        initValue: Boolean
    ) {
        if (initialValues.containsKey(graphicController)) {
            initialValues.remove(graphicController)
        }
        initialValues[graphicController] = initValue
        handleGraphicsFilterZoom(
            graphicController,
            symbolVisibilityFilter,
            flutterMapViewDelegate.mapScale
        )
        if (graphicControllers.containsKey(graphicController)) {
            if (graphicControllers[graphicController] === symbolVisibilityFilter) {
                return
            }
            graphicControllers.remove(graphicController)
        }
        graphicControllers[graphicController] = symbolVisibilityFilter
        handleRegistrationToScaleChanged()
    }

    fun removeGraphicsController(graphicController: GraphicControllerSink) {
        if (!containsGraphicsController(graphicController)) {
            return
        }
        graphicController.setVisible(initialValues.remove(graphicController))
        graphicControllers.remove(graphicController)
        handleRegistrationToScaleChanged()
    }

    override fun mapScaleChanged(mapScaleChangedEvent: MapScaleChangedEvent) {
        invalidate()
    }

    fun invalidate() {
        for ((key, value) in graphicControllers) {
            handleGraphicsFilterZoom(key, value, flutterMapViewDelegate.mapScale)
        }
    }

    private fun handleGraphicsFilterZoom(
        graphicController: GraphicControllerSink,
        visibilityFilter: SymbolVisibilityFilter?,
        currentZoom: Double
    ) {
        if (java.lang.Double.isNaN(currentZoom)) {
            return
        }
        if (currentZoom < visibilityFilter.getMinZoom() && currentZoom > visibilityFilter.getMaxZoom()) {
            graphicController.setVisible(initialValues[graphicController])
        } else {
            if (!graphicController.isSelected) {
                graphicController.visible = false
            }
        }
    }

    private fun handleRegistrationToScaleChanged() {
        if (graphicControllers.size > 0 && !isRegister) {
            isRegister = true
            flutterMapViewDelegate.addMapScaleChangedListener(this)
        } else if (graphicControllers.size == 0 && isRegister) {
            isRegister = false
            flutterMapViewDelegate.removeMapScaleChangedListener(this)
        }
    }
}