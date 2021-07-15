//
// Created by Valentin Grigorean on 14.07.2021.
//

import Foundation
import ArcGIS

class LegendInfoController {

    private let layersController: LayersController
    private var layersLegend = Dictionary<LayerWrapper,[AGSLegendInfo]>()

    init(layersController: LayersController) {
        self.layersController = layersController
    }


}

fileprivate struct LayerWrapper: Hashable {

    let layer: AGSLayerContent

    func hash(into hasher: inout Hasher) {
        hasher.combine(LayerWrapper.objectIdentifierFor(layer))
    }

    static func ==(lhs: LayerWrapper,
                   rhs: LayerWrapper) -> Bool {
        lhs.layer === rhs.layer
    }

    private static func objectIdentifierFor(_ obj: AnyObject) -> UInt {
        UInt(bitPattern: ObjectIdentifier(obj))
    }
}