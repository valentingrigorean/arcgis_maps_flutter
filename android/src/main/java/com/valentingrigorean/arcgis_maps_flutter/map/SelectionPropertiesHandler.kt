package com.valentingrigorean.arcgis_maps_flutter.map

import android.graphics.Color
import com.esri.arcgisruntime.mapping.SelectionProperties
import com.esri.arcgisruntime.mapping.view.Graphic

class SelectionPropertiesHandler(private val selectionProperties: SelectionProperties?) {
    private val defaultSelectedColor: Int

    init {
        defaultSelectedColor = selectionProperties!!.color
    }

    fun setSelected(graphic: Graphic, selectedColor: Color?) {
        if (selectedColor != null) {
            selectionProperties!!.color = selectedColor.toArgb()
        } else {
            reset()
        }
        graphic.isSelected = true
    }

    fun clearSelection(graphic: Graphic) {
        graphic.isSelected = false
        reset()
    }

    fun reset() {
        if (selectionProperties!!.color == defaultSelectedColor) return
        selectionProperties.color = defaultSelectedColor
    }
}