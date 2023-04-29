package com.valentingrigorean.arcgis_maps_flutter.map

import android.content.Context
import com.esri.arcgisruntime.mapping.view.Graphic
import com.esri.arcgisruntime.mapping.view.GraphicsOverlay
import com.valentingrigorean.arcgis_maps_flutter.Convert
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
            if (controller.canConsumeTapEvents()) {
                return true
            }
        }
        return false
    }

    override fun didHandleGraphic(graphic: Graphic): Boolean {
        val rawMarkerId = graphic.attributes["markerId"] ?: return false
        val markerId = rawMarkerId as String
        val markerController = markerIdToController[markerId]
        if (markerController == null || !markerController.canConsumeTapEvents()) {
            return false
        }
        if (selectedMarker != null) selectedMarker!!.isSelected = false
        markerController.isSelected = true
        selectedMarker = markerController
        invalidateVisibilityFilterController(selectedMarker!!)
        methodChannel.invokeMethod("marker#onTap", Convert.Companion.markerIdToJson(markerId))
        return true
    }

    fun addMarkers(markersToAdd: List<Any?>?) {
        if (markersToAdd == null) {
            return
        }
        for (marker in markersToAdd) {
            val data = marker as Map<*, *>? ?: continue
            val markerId = data["markerId"] as String?
            val markerController = MarkerController(context, markerId)
            markerController.setSelectionPropertiesHandler(selectionPropertiesHandler)
            markerIdToController[markerId] = markerController
            Convert.Companion.interpretMarkerController(
                data,
                markerController,
                symbolVisibilityFilterController
            )
            markerController.add(graphicsOverlay)
        }
    }

    fun changeMarkers(markersToChange: List<Any?>?) {
        if (markersToChange == null) {
            return
        }
        for (marker in markersToChange) {
            val data = marker as Map<*, *>? ?: continue
            val markerId = data["markerId"] as String?
            val markerController = markerIdToController[markerId]
            if (markerController != null) {
                Convert.Companion.interpretMarkerController(
                    data,
                    markerController,
                    symbolVisibilityFilterController
                )
            }
        }
    }

    fun removeMarkers(markerIdsToRemove: List<Any?>?) {
        if (markerIdsToRemove == null) {
            return
        }
        for (rawMarkerId in markerIdsToRemove) {
            if (rawMarkerId == null) {
                continue
            }
            val markerId = rawMarkerId as String
            val markerController = markerIdToController.remove(markerId)
            if (markerController != null) {
                onSymbolRemoval(markerController)
                markerController.remove(graphicsOverlay)
            }
        }
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