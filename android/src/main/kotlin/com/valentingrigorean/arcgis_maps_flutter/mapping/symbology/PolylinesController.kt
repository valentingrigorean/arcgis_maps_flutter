package com.valentingrigorean.arcgis_maps_flutter.mapping.symbology

import com.arcgismaps.mapping.view.Graphic
import com.arcgismaps.mapping.view.GraphicsOverlay
import com.valentingrigorean.arcgis_maps_flutter.convert.map.toPolylineIdValue
import com.valentingrigorean.arcgis_maps_flutter.map.MapTouchGraphicDelegate
import io.flutter.plugin.common.MethodChannel

class PolylinesController(
    private val methodChannel: MethodChannel,
    private val graphicsOverlay: GraphicsOverlay
) : BaseSymbolController(), MapTouchGraphicDelegate {
    private val polylineIdToController: MutableMap<String?, PolylineController> = HashMap()
    override fun canConsumeTaps(): Boolean {
        for (controller in polylineIdToController.values) {
            if (controller.consumeTapEvents) {
                return true
            }
        }
        return false
    }

    override fun didHandleGraphic(graphic: Graphic): Boolean {
        val rawPolylineId = graphic.attributes["polylineId"] ?: return false
        val polylineId = rawPolylineId as String
        val controller = polylineIdToController[polylineId]
        if (controller == null || !controller.consumeTapEvents) {
            return false
        }
        methodChannel.invokeMethod("polyline#onTap", polylineId.toPolylineIdValue())
        return true
    }

    fun addPolylines(polylinesToAdd: List<Any>?) {
        if (polylinesToAdd == null) {
            return
        }
        for (polyline in polylinesToAdd) {
            val data = polyline as Map<*, *>? ?: continue
            val polylineId = data["polylineId"] as String
            val controller = PolylineController(polylineId)
            controller.setSelectionPropertiesHandler(selectionPropertiesHandler)
            controller.interpretGraphicController(data, symbolVisibilityFilterController)
            polylineIdToController[polylineId] = controller
            controller.add(graphicsOverlay)
        }
    }

    fun changePolylines(polylinesToChange: List<Any>?) {
        if (polylinesToChange == null) {
            return
        }
        for (polyline in polylinesToChange) {
            val data = polyline as Map<*, *>? ?: continue
            val polylineId = data["polylineId"] as String?
            polylineIdToController[polylineId]?.interpretGraphicController(
                data,
                symbolVisibilityFilterController
            )
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