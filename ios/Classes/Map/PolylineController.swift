//
// Created by Valentin Grigorean on 28.04.2021.
//

import Foundation
import ArcGIS

class PolylineController: BaseGraphicController {
    private let polylineSymbol: AGSSimpleLineSymbol

    init(polylineId: String) {
        polylineSymbol = AGSSimpleLineSymbol(style: .solid, color: UIColor.black, width: 10)
        super.init(graphics: AGSGraphic(geometry: nil, symbol: polylineSymbol, attributes: ["polylineId": polylineId]))
    }

    func setVisible(visible: Bool) {
        graphics.isVisible = visible
    }

    func setColor(color: UIColor) {
        polylineSymbol.color = color
    }

    func setStyle(style: AGSSimpleLineSymbolStyle) {
        polylineSymbol.style = style
    }

    func setPoints(points: [AGSPoint]) {
        graphics.geometry = AGSPolyline(points: points)
    }

    func setWidth(width: CGFloat) {
        polylineSymbol.width = width
    }

    func setZIndex(zIndex: Int) {
        graphics.zIndex = zIndex
    }

    func setAntialias(antialias: Bool) {
        polylineSymbol.antialias = antialias
    }
}