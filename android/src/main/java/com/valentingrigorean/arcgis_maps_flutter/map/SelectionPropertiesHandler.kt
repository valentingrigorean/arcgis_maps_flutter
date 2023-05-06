package com.valentingrigorean.arcgis_maps_flutter.map

import android.graphics.Color
import com.arcgismaps.mapping.view.Graphic
import com.arcgismaps.mapping.view.SelectionProperties

class SelectionPropertiesHandler(private val selectionProperties: SelectionProperties) {
    private val defaultSelectedColor: com.arcgismaps.Color = selectionProperties.color

    fun setSelected(graphic: Graphic, selectedColor: Color?) {
        if (selectedColor != null) {
            selectionProperties.color = com.arcgismaps.Color(selectedColor.toArgb())
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
        if (selectionProperties.color == defaultSelectedColor) return
        selectionProperties.color = defaultSelectedColor
    }
}