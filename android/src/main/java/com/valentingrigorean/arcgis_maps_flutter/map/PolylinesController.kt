package com.valentingrigorean.arcgis_maps_flutter.map

import com.esri.arcgisruntime.mapping.view.Graphic
import com.esri.arcgisruntime.mapping.view.GraphicsOverlay
import com.valentingrigorean.arcgis_maps_flutter.Convert
import io.flutter.plugin.common.MethodChannel

class PolylinesController(
    private val methodChannel: MethodChannel,
    private val graphicsOverlay: GraphicsOverlay
) : BaseSymbolController(), MapTouchGraphicDelegate {
    val polylineIdToController: MutableMap<String?, PolylineController> = HashMap()
    override fun canConsumeTaps(): Boolean {
        for (controller in polylineIdToController.values) {
            if (controller.canConsumeTapEvents()) {
                return true
            }
        }
        return false
    }

    override fun didHandleGraphic(graphic: Graphic): Boolean {
        val rawPolylineId = graphic.attributes["polylineId"] ?: return false
        val polylineId = rawPolylineId as String
        val controller = polylineIdToController[polylineId]
        if (controller == null || !controller.canConsumeTapEvents()) {
            return false
        }
        methodChannel.invokeMethod("polyline#onTap", Convert.Companion.polylineIdToJson(polylineId))
        return true
    }

    fun addPolylines(polylinesToAdd: List<Any>?) {
        if (polylinesToAdd == null) {
            return
        }
        for (polyline in polylinesToAdd) {
            val data = polyline as Map<*, *> ?: continue
            val polylineId = data["polylineId"] as String?
            val controller = PolylineController(polylineId)
            controller.setSelectionPropertiesHandler(selectionPropertiesHandler)
            polylineIdToController[polylineId] = controller
            Convert.Companion.interpretPolylineController(
                data,
                controller,
                symbolVisibilityFilterController
            )
            controller.add(graphicsOverlay)
        }
    }

    fun changePolylines(polylinesToChange: List<Any>?) {
        if (polylinesToChange == null) {
            return
        }
        for (polyline in polylinesToChange) {
            val data = polyline as Map<*, *> ?: continue
            val polylineId = data["polylineId"] as String?
            val controller = polylineIdToController[polylineId]
            if (controller != null) {
                Convert.Companion.interpretPolylineController(
                    data,
                    controller,
                    symbolVisibilityFilterController
                )
            }
        }
    }

    fun removePolylines(polylineIdsToRemove: List<Any>?) {
        if (polylineIdsToRemove == null) {
            return
        }
        for (rawPolylineId in polylineIdsToRemove) {
            if (rawPolylineId == null) {
                continue
            }
            val polylineId = rawPolylineId as String
            val controller = polylineIdToController.remove(polylineId)
            if (controller != null) {
                onSymbolRemoval(controller)
                controller.remove(graphicsOverlay)
            }
        }
    }
}