//
// Created by Valentin Grigorean on 27.06.2021.
//

import Foundation
import ArcGIS

class SelectionPropertiesHandler {
    private let selectionProperties: AGSSelectionProperties
    private let defaultSelectedColor: UIColor

    init(selectionProperties: AGSSelectionProperties) {
        self.selectionProperties = selectionProperties
        defaultSelectedColor = selectionProperties.color
    }

    func setGraphicSelected(graphic: AGSGraphic,
                            selectedColor: UIColor?) {
        if let selectedColor = selectedColor {
            selectionProperties.color = selectedColor
        } else {
            reset()
        }
        graphic.isSelected = true
    }

    func clearGraphicsSelection(graphic: AGSGraphic) {
        graphic.isSelected = false
        reset()
    }

    func reset() {
        selectionProperties.color = defaultSelectedColor
    }

}