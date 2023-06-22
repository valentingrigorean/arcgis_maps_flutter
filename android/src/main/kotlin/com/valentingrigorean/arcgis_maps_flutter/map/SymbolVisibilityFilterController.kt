package com.valentingrigorean.arcgis_maps_flutter.map

import com.arcgismaps.mapping.view.MapView
import com.valentingrigorean.arcgis_maps_flutter.mapping.symbology.GraphicControllerSink
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach

class SymbolVisibilityFilterController(
    private val mapView: MapView,
    scope: CoroutineScope
) {
    private val graphicControllers: MutableMap<GraphicControllerSink, SymbolVisibilityFilter> =
        HashMap()
    private val initialValues: MutableMap<GraphicControllerSink, Boolean> = HashMap()

    init {
        mapView.mapScale.onEach {
            invalidate()
        }.launchIn(scope)
    }

    fun clear() {
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
                graphicControllers[graphicController]!!,
                mapView.mapScale.value
            )
        }
    }

    fun addGraphicsController(
        graphicController: GraphicControllerSink,
        symbolVisibilityFilter: SymbolVisibilityFilter,
        initValue: Boolean
    ) {
        if (initialValues.containsKey(graphicController)) {
            initialValues.remove(graphicController)
        }
        initialValues[graphicController] = initValue
        handleGraphicsFilterZoom(
            graphicController,
            symbolVisibilityFilter,
            mapView.mapScale.value
        )
        if (graphicControllers.containsKey(graphicController)) {
            if (graphicControllers[graphicController] === symbolVisibilityFilter) {
                return
            }
            graphicControllers.remove(graphicController)
        }
        graphicControllers[graphicController] = symbolVisibilityFilter
    }

    fun removeGraphicsController(graphicController: GraphicControllerSink) {
        if (!containsGraphicsController(graphicController)) {
            return
        }
        graphicController.visible = initialValues.remove(graphicController) ?: true
        graphicControllers.remove(graphicController)
    }


    fun invalidate() {
        for ((key, value) in graphicControllers) {
            handleGraphicsFilterZoom(key, value, mapView.mapScale.value)
        }
    }

    private fun handleGraphicsFilterZoom(
        graphicController: GraphicControllerSink,
        visibilityFilter: SymbolVisibilityFilter,
        currentZoom: Double
    ) {
        if (java.lang.Double.isNaN(currentZoom)) {
            graphicController.visible = initialValues[graphicController] ?: true
            return
        }
        if (currentZoom < visibilityFilter.minZoom || currentZoom > visibilityFilter.maxZoom) {
            graphicController.visible = false
        } else {
            // visible when it's in the zoom range or if it's selected
            graphicController.visible = graphicController.isSelected || initialValues[graphicController] ?: true
        }
    }

}