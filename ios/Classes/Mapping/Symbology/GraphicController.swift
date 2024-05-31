//
// Created by Valentin Grigorean on 29.05.2024.
//

import Foundation
import ArcGIS

class GraphicMarkerController: BaseGraphicController {
    init(graphicId: String) {
        super.init(graphics: Graphic(geometry: nil, attributes: ["graphicId": graphicId], symbol: nil))
    }

    var symbol: Symbol? {
        get {
            graphics.symbol
        }
        set {
            graphics.symbol = newValue
        }
    }
    
    override var isSelected: Bool{
        get{
            graphics.isSelected
        }
        set{
            graphics.isSelected = newValue
        }
    }
}
