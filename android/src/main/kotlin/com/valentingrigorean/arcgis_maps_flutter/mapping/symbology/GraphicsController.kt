package com.valentingrigorean.arcgis_maps_flutter.mapping.symbology

import android.content.Context
import com.arcgismaps.mapping.view.Graphic
import com.arcgismaps.mapping.view.GraphicsOverlay
import com.valentingrigorean.arcgis_maps_flutter.convert.map.toGraphicIdValue
import com.valentingrigorean.arcgis_maps_flutter.map.MapTouchGraphicDelegate
import io.flutter.plugin.common.MethodChannel

class GraphicsController (
    private val context: Context,
    private val methodChannel: MethodChannel,
    private val graphicsOverlay: GraphicsOverlay
) : BaseSymbolController(), MapTouchGraphicDelegate {

    private val graphicIdToController: MutableMap<String?, GraphicController> = HashMap()
    private var selectedGraphic: GraphicController? = null

    override fun canConsumeTaps(): Boolean {
        for (controller in graphicIdToController.values) {
            if (controller.consumeTapEvents) {
                return true
            }
        }
        return false
    }

    override fun didHandleGraphic(graphic: Graphic): Boolean {
        val graphicId = graphic.attributes["graphicId"]?.toString() ?: return false

        val graphicController = graphicIdToController[graphicId]
        if (graphicController == null || !graphicController.consumeTapEvents) {
            return false
        }
        if (selectedGraphic != null) selectedGraphic!!.isSelected = false
        graphicController.isSelected = true
        selectedGraphic = graphicController
        invalidateVisibilityFilterController(selectedGraphic!!)
        methodChannel.invokeMethod("graphic#onTap", graphicId.toGraphicIdValue())
        return true
    }

    fun addGraphics(graphicsToAdd: List<Any>?) {
        if (graphicsToAdd == null) {
            return
        }
        val graphicsAdded = ArrayList<Graphic>(graphicsToAdd.size)
        for (graphic in graphicsToAdd) {
            val data = graphic as Map<*, *>? ?: continue
            val graphicId = data["graphicId"] as String
            val graphicController = GraphicController(context, graphicId)
            graphicController.setSelectionPropertiesHandler(selectionPropertiesHandler)
            graphicController.interpretGraphicController(data, symbolVisibilityFilterController)
            graphicIdToController[graphicId] = graphicController
            graphicsAdded.add(graphicController.graphic)
        }

        graphicsOverlay.graphics.addAll(graphicsAdded)
    }

    fun changeGraphics(graphicsToChange: List<Any?>?) {
        if (graphicsToChange == null) {
            return
        }
        for (graphic in graphicsToChange) {
            val data = graphic as Map<*, *>? ?: continue
            val graphicId = data["graphicId"] as String
            val graphicController = graphicIdToController[graphicId] ?: continue
            graphicController.interpretGraphicController(data, symbolVisibilityFilterController)
        }
    }

    fun removeGraphics(graphicIdsToRemove: List<Any>?) {
        if (graphicIdsToRemove == null) {
            return
        }
        val graphicsToRemove = ArrayList<Graphic>(graphicIdsToRemove.size)
        for (rawGraphicId in graphicIdsToRemove) {
            val graphicId = rawGraphicId as String
            val graphicController = graphicIdToController.remove(graphicId)
            if (graphicController != null) {
                graphicsToRemove.add(graphicController.graphic)
            }
        }
        graphicsOverlay.graphics.removeAll(graphicsToRemove)
    }


}