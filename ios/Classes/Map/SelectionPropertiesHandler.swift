//
// Created by Valentin Grigorean on 27.06.2021.
//

import SwiftUI
import ArcGIS

class SelectionPropertiesHandler {
    private let mapViewModel: MapViewModel
    private let defaultSelectedColor: Color
    private var selectedColor: Color

    init(mapViewModel: MapViewModel) {
        self.mapViewModel = mapViewModel
        defaultSelectedColor = mapViewModel.selectedColor
        selectedColor = defaultSelectedColor
    }

    func setGraphicSelected(graphic: Graphic,
                            selectedColor: Color?) {
        if let newSelectedColor = selectedColor {
            mapViewModel.selectedColor = newSelectedColor
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
        mapViewModel.selectedColor = defaultSelectedColor
    }
}