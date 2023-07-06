//
// Created by Valentin Grigorean on 08.09.2021.
//

import Foundation

protocol SymbolsController {
    var symbolVisibilityFilterController: SymbolVisibilityFilterController? { get set }

    var selectionPropertiesHandler: SelectionPropertiesHandler? { get set }
}

extension SymbolsController {
    func updateController(controller: BaseGraphicController,
                          data: [String: Any]) {
        if let consumeTapEvents = data["consumeTapEvents"] as? Bool {
            controller.consumeTapEvents = consumeTapEvents
        }

        if let visible = data["visible"] as? Bool {
            let visibilityFilter = data["visibilityFilter"] as? [String: Any]
            let symbolVisibilityFilterController = symbolVisibilityFilterController
            if visibilityFilter != nil && symbolVisibilityFilterController != nil {
                symbolVisibilityFilterController?.addGraphicsController(graphicController: controller, visibilityFilter: SymbolVisibilityFilter(data: visibilityFilter!), initValue: visible)
            } else {
                controller.isVisible = visible
            }
        }

        if let zIndex = data["zIndex"] as? Int {
            controller.zIndex = zIndex
        }

        controller.selectedColor = UIColor(data: data["selectedColor"])
    }
}
