//
// Created by Valentin Grigorean on 28.04.2021.
//

import Foundation
import ArcGIS

class PolylineController: BaseGraphicController {
    private let polylineSymbol: SimpleLineSymbol

    init(polylineId: String) {
        polylineSymbol = SimpleLineSymbol(style: .solid, color: UIColor.black, width: 10)
        super.init(graphics: Graphic(geometry: nil, attributes: ["polylineId": polylineId], symbol: polylineSymbol))
    }

    func setVisible(visible: Bool) {
        graphics.isVisible = visible
    }

    func setColor(color: UIColor) {
        polylineSymbol.color = color
    }

    func setStyle(style: SimpleLineSymbol.Style) {
        polylineSymbol.style = style
    }

    func setPoints(points: [Point]) {
        graphics.geometry = Polyline(points: points)
    }

    func setWidth(width: CGFloat) {
        polylineSymbol.width = width
    }

    func setZIndex(zIndex: Int) {
        graphics.zIndex = zIndex
    }

    func setAntialias(antialias: Bool) {
        polylineSymbol.isAntialiased = antialias
    }
}
