package com.valentingrigorean.arcgis_maps_flutter.mapping.symbology

import android.content.Context
import com.arcgismaps.mapping.view.Graphic
import com.arcgismaps.mapping.view.GraphicsOverlay
import com.valentingrigorean.arcgis_maps_flutter.convert.map.toMarkerIdValue
import com.valentingrigorean.arcgis_maps_flutter.map.MapTouchGraphicDelegate
import io.flutter.plugin.common.MethodChannel

class MarkersController(
    private val context: Context,
    private val methodChannel: MethodChannel,
    private val graphicsOverlay: GraphicsOverlay
) : BaseSymbolController(), MapTouchGraphicDelegate {
    private val markerIdToController: MutableMap<String?, MarkerController> = HashMap()
    private var selectedMarker: MarkerController? = null
    override fun canConsumeTaps(): Boolean {
        for (controller in markerIdToController.values) {
            if (controller.consumeTapEvents) {
                return true
            }
        }
        return false
    }

    override fun didHandleGraphic(graphic: Graphic): Boolean {
        val rawMarkerId = graphic.attributes["markerId"] ?: return false
        val markerId = rawMarkerId as String
        val markerController = markerIdToController[markerId]
        if (markerController == null || !markerController.consumeTapEvents) {
            return false
        }
        if (selectedMarker != null) selectedMarker!!.isSelected = false
        markerController.isSelected = true
        selectedMarker = markerController
        invalidateVisibilityFilterController(selectedMarker!!)
        methodChannel.invokeMethod("marker#onTap", markerId.toMarkerIdValue())
        return true
    }

    fun addMarkers(markersToAdd: List<Any>?) {
        if (markersToAdd == null) {
            return
        }
        val graphicsAdded = ArrayList<Graphic>(markersToAdd.size)
        for (marker in markersToAdd) {
            val data = marker as Map<*, *>? ?: continue
            val markerId = data["markerId"] as String
            val markerController = MarkerController(context, markerId)
            markerController.setSelectionPropertiesHandler(selectionPropertiesHandler)
            markerController.interpretGraphicController(data, symbolVisibilityFilterController)
            markerIdToController[markerId] = markerController
            graphicsAdded.add(markerController.graphic)
        }

        graphicsOverlay.graphics.addAll(graphicsAdded)
    }

    fun changeMarkers(markersToChange: List<Any?>?) {
        if (markersToChange == null) {
            return
        }
        for (marker in markersToChange) {
            val data = marker as Map<*, *>? ?: continue
            val markerId = data["markerId"] as String
            markerIdToController[markerId]?.interpretGraphicController(
                data,
                symbolVisibilityFilterController
            )
        }
    }

    fun removeMarkers(markerIdsToRemove: List<Any>?) {
        if (markerIdsToRemove == null) {
            return
        }
        val graphicsToRemove = ArrayList<Graphic>(markerIdsToRemove.size)
        for (rawMarkerId in markerIdsToRemove) {
            val markerId = rawMarkerId as String
            val markerController = markerIdToController.remove(markerId)
            if (markerController != null) {
                onSymbolRemoval(markerController)
                graphicsToRemove.add(markerController.graphic)
            }
        }
        graphicsOverlay.graphics.removeAll(graphicsToRemove)
    }

    fun clearSelectedMarker() {
        if (selectedMarker == null) {
            return
        }
        selectedMarker!!.isSelected = false
        invalidateVisibilityFilterController(selectedMarker!!)
        selectedMarker = null
    }
}