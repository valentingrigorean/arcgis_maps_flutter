package com.valentingrigorean.arcgis_maps_flutter.mapping.symbology

import com.arcgismaps.Color
import com.arcgismaps.geometry.Geometry
import com.arcgismaps.mapping.view.Graphic
import com.arcgismaps.mapping.view.GraphicsOverlay
import com.valentingrigorean.arcgis_maps_flutter.convert.map.toSymbolVisibilityFilterOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.toArcgisColor
import com.valentingrigorean.arcgis_maps_flutter.map.SelectionPropertiesHandler
import com.valentingrigorean.arcgis_maps_flutter.map.SymbolVisibilityFilterController

abstract class BaseGraphicController(
    override var consumeTapEvents: Boolean = false,
    override var selectedColor: Color? = null,
) : GraphicControllerSink {
    private var selectionPropertiesHandler: SelectionPropertiesHandler? = null
    protected val graphic = Graphic()

    override var geometry: Geometry?
        get() = graphic.geometry
        set(value) {
            graphic.geometry = value
        }

    override var zIndex: Int
        get() = graphic.zIndex
        set(value) {
            graphic.zIndex = value
        }

    override var visible: Boolean
        get() = graphic.isVisible
        set(visible) {
            graphic.isVisible = visible
        }


    override var isSelected: Boolean
        get() = graphic.isSelected
        set(selected) {
            val graphic = graphic
            if (selected && !graphic.isSelected) {
                selectionPropertiesHandler?.setSelected(graphic, selectedColor)
            } else if (graphic.isSelected) {
                selectionPropertiesHandler?.clearSelection(graphic)
            }
        }


    fun setSelectionPropertiesHandler(selectionPropertiesHandler: SelectionPropertiesHandler?) {
        this.selectionPropertiesHandler = selectionPropertiesHandler
    }

    override fun add(graphicsOverlay: GraphicsOverlay) {
        graphicsOverlay.graphics.add(graphic)
    }

    override fun remove(graphicsOverlay: GraphicsOverlay) {
        graphicsOverlay.graphics.remove(graphic)
    }

    override fun interpretGraphicController(
        data: Map<*, *>,
        symbolVisibilityFilterController: SymbolVisibilityFilterController?,
    ) {
        val consumeTapEvents = data["consumeTapEvents"] as Boolean?
        if (consumeTapEvents != null) {
            this.consumeTapEvents = consumeTapEvents
        }
        val visible = data["visible"] as Boolean?
        if (visible != null) {
            val visibilityFilter = data["visibilityFilter"]?.toSymbolVisibilityFilterOrNull()
            if (symbolVisibilityFilterController != null && visibilityFilter != null) {
                symbolVisibilityFilterController!!.addGraphicsController(
                    this,
                    visibilityFilter,
                    visible
                )
            } else {
                this.visible = visible
            }
        }
        val zIndex = data["zIndex"] as Int?
        if (zIndex != null) {
            this.zIndex = zIndex
        }
        val selectedColor = (data["selectedColor"] as Int?)?.toArcgisColor()
        if (selectedColor != null) {
            this.selectedColor = selectedColor
        }
    }
}