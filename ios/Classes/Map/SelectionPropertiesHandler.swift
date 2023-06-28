//
// Created by Valentin Grigorean on 27.06.2021.
//

import SwiftUI
import ArcGIS

class SelectionPropertiesHandler {
    private let geoView: any GeoView
    private let defaultSelectedColor: Color
    private var selectedColor: Color

    init(geoView: any GeoView) {
        self.geoView = geoView
        defaultSelectedColor = Color.cyan
        selectedColor = defaultSelectedColor
    }

    func setGraphicSelected(graphic: Graphic,
                            selectedColor: Color?) {
        if let newSelectedColor = selectedColor {
            geoView.selectionColor(newSelectedColor)
            self.selectedColor = newSelectedColor
        } else {
            reset()
        }
        graphic.isSelected = true
    }

    func clearGraphicsSelection(graphic: Graphic) {
        graphic.isSelected = false
        reset()
    }

    func reset() {
        if selectedColor == defaultSelectedColor {
            return
        }
        selectedColor = defaultSelectedColor
        geoView.selectionColor(selectedColor)
    }
}