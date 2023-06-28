//
// Created by Valentin Grigorean on 29.03.2021.
//

import Foundation
import ArcGIS

protocol MapGraphicTouchDelegate {
    func canConsumeTaps() -> Bool

    func didHandleGraphic(graphic: Graphic) -> Bool
}
