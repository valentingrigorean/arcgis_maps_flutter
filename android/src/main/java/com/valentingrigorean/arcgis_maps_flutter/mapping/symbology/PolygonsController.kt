package com.valentingrigorean.arcgis_maps_flutter.mapping.symbology

import com.arcgismaps.mapping.view.Graphic
import com.arcgismaps.mapping.view.GraphicsOverlay
import com.valentingrigorean.arcgis_maps_flutter.Convert
import com.valentingrigorean.arcgis_maps_flutter.convert.map.toPolygonIdValue
import com.valentingrigorean.arcgis_maps_flutter.map.MapTouchGraphicDelegate
import io.flutter.plugin.common.MethodChannel

class PolygonsController(
    private val methodChannel: MethodChannel,
    private val graphicsOverlay: GraphicsOverlay
) : BaseSymbolController(), MapTouchGraphicDelegate {
    private val polygonIdToController: MutableMap<String?, PolygonController> = HashMap()
    override fun canConsumeTaps(): Boolean {
        for (controller in polygonIdToController.values) {
            if (controller.canConsumeTapEvents()) {
                return true
            }
        }
        return false
    }

    override fun didHandleGraphic(graphic: Graphic): Boolean {
        val rawPolygonId = graphic.attributes["polygonId"] ?: return false
        val polygonId = rawPolygonId as String
        val controller = polygonIdToController[polygonId]
        if (controller == null || !controller.canConsumeTapEvents()) {
            return false
        }
        methodChannel.invokeMethod("polygon#onTap", polygonId.toPolygonIdValue())
        return true
    }



    fun addPolygons(polygonsToAdd: List<Any?>?) {
        if (polygonsToAdd == null) {
            return
        }
        for (polygon in polygonsToAdd) {
            val data = polygon as Map<*, *>? ?: continue
            val polygonId = data["polygonId"] as String?
            val controller = PolygonController(polygonId)
            controller.setSelectionPropertiesHandler(selectionPropertiesHandler)
            polygonIdToController[polygonId] = controller
            interpretBaseGraphicController(data, controller)
            Convert.Companion.interpretPolygonController(
                data,
                controller,
                symbolVisibilityFilterController
            )
            controller.add(graphicsOverlay)
        }
    }

    fun changePolygons(polygonsToChange: List<Any?>?) {
        if (polygonsToChange == null) {
            return
        }
        for (polygon in polygonsToChange) {
            val data = polygon as Map<*, *>? ?: continue
            val polygonId = data["polygonId"] as String?
            val controller = polygonIdToController[polygonId] ?: continue
            Convert.Companion.interpretPolygonController(
                data,
                controller,
                symbolVisibilityFilterController
            )
        }
    }

    fun removePolygons(polygonIdsToRemove: List<Any?>?) {
        if (polygonIdsToRemove == null) {
            return
        }
        for (rawPolygonId in polygonIdsToRemove) {
            if (rawPolygonId == null) {
                continue
            }
            val polygonId = rawPolygonId as String
            val controller = polygonIdToController.remove(polygonId)
            if (controller != null) {
                onSymbolRemoval(controller)
                controller.remove(graphicsOverlay)
            }
        }
    }
}