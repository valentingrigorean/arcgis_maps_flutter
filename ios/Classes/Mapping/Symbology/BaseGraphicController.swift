//
// Created by Valentin Grigorean on 27.06.2021.
//

import Foundation
import ArcGIS

protocol GraphicController {
    var graphics: Graphic { get }

    var selectionPropertiesHandler: SelectionPropertiesHandler? { get set }

    var consumeTapEvents: Bool { get set }

    var geometry: Geometry? { get set }

    var isVisible: Bool { get set }

    var isSelected: Bool { get set }

    var selectedColor: UIColor? { get set }

    var zIndex: Int { get set }
}

extension GraphicController {

    func add(graphicsOverlay: GraphicsOverlay) {
        graphicsOverlay.addGraphic(graphics)
    }

    func remove(graphicsOverlay: GraphicsOverlay) {
        graphicsOverlay.removeGraphic(graphics)
    }
}

class BaseGraphicController: GraphicController {

    init(graphics: Graphic) {
        self.graphics = graphics
        consumeTapEvents = false
    }

    let graphics: Graphic

    var selectionPropertiesHandler: SelectionPropertiesHandler?

    var consumeTapEvents: Bool

    var geometry: Geometry? {
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
                    selectionPropertiesHandler?.setGraphicSelected(graphic: graphics, selectedColor: selectedColor?.toSwiftUIColor())
                } else {
                    selectionPropertiesHandler?.clearGraphicsSelection(graphic: graphics)
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
