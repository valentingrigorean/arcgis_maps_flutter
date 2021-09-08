//
// Created by Valentin Grigorean on 08.09.2021.
//

import Foundation

protocol BaseSymbolController {

}

extension BaseSymbolController {
    func addOrRemoveVisibilityFilter(symbolVisibilityFilterController: SymbolVisibilityFilterController,
                                     graphicController: BaseGraphicController,
                                     data: Dictionary<String, Any>) {
        if let visibilityFilter = data["visibilityFilter"] as? Dictionary<String, Any> {
            symbolVisibilityFilterController.addGraphicsController(graphicController: graphicController, visibilityFilter: SymbolVisibilityFilter(data: visibilityFilter), initValue: graphicController.isVisible)
        } else {
            symbolVisibilityFilterController.removeGraphicsController(graphicController: graphicController)
        }
    }
}