//
// Created by Valentin Grigorean on 16.04.2021.
//

import Foundation
import ArcGIS

class PolygonController : BaseGraphicController {
    private let polygonSymbol: SimpleFillSymbol
    private let polygonStrokeSymbol: SimpleLineSymbol


    init(polygonId: String) {
        polygonStrokeSymbol = SimpleLineSymbol(style: .solid, color: UIColor.black, width: 10)
        polygonSymbol = SimpleFillSymbol(style: .solid, color: UIColor.black, outline: polygonStrokeSymbol)
        super.init(graphics: Graphic(geometry: nil, attributes: ["polygonId": polygonId],symbol: polygonSymbol))
    }

    func setVisible(visible: Bool) {
        graphics.isVisible = visible
    }

    func setFillColor(fillColor: UIColor) {
        polygonSymbol.color = fillColor
    }

    func setStrokeColor(strokeColor: UIColor) {
        polygonStrokeSymbol.color = strokeColor
    }

    func setPoints(points: [Point]) {
        graphics.geometry = Polygon(points: points)
    }

    func setStrokeWidth(width: CGFloat) {
        polygonStrokeSymbol.width = width
    }

    func setStrokeStyle(style: SimpleLineSymbol.Style) {
        polygonStrokeSymbol.style = style
    }

    func setZIndex(zIndex: Int) {
        graphics.zIndex = zIndex
    }
}
