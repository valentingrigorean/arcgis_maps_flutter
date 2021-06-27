//
// Created by Valentin Grigorean on 27.06.2021.
//

import Foundation
import ArcGIS

protocol GraphicController {
    var graphics: AGSGraphic { get }

    var selectionPropertiesHandler: SelectionPropertiesHandler { get }
    var consumeTapEvents: Bool { get set }

    var geometry: AGSGeometry? { get set }

    var isVisible: Bool { get set }

    var isSelected: Bool { get set }

    var selectedColor: UIColor? { get set }

    var zIndex: Int { get set }
}

extension GraphicController {

    func add(graphicsOverlay: AGSGraphicsOverlay) {
        graphicsOverlay.graphics.add(graphics)
    }

    func remove(graphicsOverlay: AGSGraphicsOverlay) {
        graphicsOverlay.graphics.remove(graphics)
    }
}

class BaseGraphicController: GraphicController {

    init(graphics: AGSGraphic,
         selectionPropertiesHandler: SelectionPropertiesHandler) {
        self.graphics = graphics
        self.selectionPropertiesHandler = selectionPropertiesHandler
        consumeTapEvents = false
    }

    let graphics: AGSGraphic

    let selectionPropertiesHandler: SelectionPropertiesHandler

    var consumeTapEvents: Bool

    var geometry: AGSGeometry? {
        get {
            graphics.geometry
        }
        set {
            graphics.geometry = newValue
        }
    }

    var isSelected: Bool = false {
        didSet {
            if oldValue != isSelected {
                if isSelected {
                    selectionPropertiesHandler.setGraphicSelected(graphic: graphics, selectedColor: selectedColor)
                } else {
                    selectionPropertiesHandler.clearGraphicsSelection(graphic: graphics)
                }
            }
        }
    }

    var selectedColor: UIColor?

    var isVisible: Bool {
        get {
            graphics.isVisible
        }
        set {
            graphics.isVisible = newValue
        }
    }

    var zIndex: Int {
        get {
            graphics.zIndex
        }
        set {
            graphics.zIndex = newValue
        }
    }


}