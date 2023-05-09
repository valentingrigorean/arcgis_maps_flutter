package com.valentingrigorean.arcgis_maps_flutter.mapping.symbology

import android.graphics.Color
import com.arcgismaps.geometry.Geometry
import com.arcgismaps.mapping.view.Graphic
import com.arcgismaps.mapping.view.GraphicsOverlay
import com.valentingrigorean.arcgis_maps_flutter.map.GraphicControllerSink
import com.valentingrigorean.arcgis_maps_flutter.map.SelectionPropertiesHandler

abstract class BaseGraphicController : GraphicControllerSink {
    private var selectionPropertiesHandler: SelectionPropertiesHandler? = null
    private var consumeTapEvents = false
    private var selectedColor: Color? = null
    protected abstract val graphic: Graphic
    fun setSelectionPropertiesHandler(selectionPropertiesHandler: SelectionPropertiesHandler?) {
        this.selectionPropertiesHandler = selectionPropertiesHandler
    }

    override fun add(graphicsOverlay: GraphicsOverlay) {
        graphicsOverlay.graphics.add(graphic)
    }

    override fun remove(graphicsOverlay: GraphicsOverlay) {
        graphicsOverlay.graphics.remove(graphic)
    }

    override var visible: Boolean
        get() = graphic.isVisible
        set(visible) {
            graphic.isVisible = visible
        }

    override fun setZIndex(zIndex: Int) {
        graphic.zIndex = zIndex
    }

    override fun setGeometry(geometry: Geometry?) {
        graphic.geometry = geometry
    }

    override var isSelected: Boolean
        get() = graphic.isSelected
        set(selected) {
            val graphic = graphic
            if (selected && !graphic.isSelected) {
                selectionPropertiesHandler!!.setSelected(graphic, selectedColor)
            } else if (graphic.isSelected) {
                selectionPropertiesHandler!!.clearSelection(graphic)
            }
        }

    override fun setConsumeTapEvents(consumeTapEvents: Boolean) {
        this.consumeTapEvents = consumeTapEvents
    }

    override fun canConsumeTapEvents(): Boolean {
        return consumeTapEvents
    }

    fun setConsumeTapEvent(consumeTapEvent: Boolean) {
        consumeTapEvents = consumeTapEvent
    }

    override fun setSelectedColor(selectedColor: Color?) {
        this.selectedColor = selectedColor
    }
}