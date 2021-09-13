//
// Created by Valentin Grigorean on 16.04.2021.
//

import Foundation
import ArcGIS

class PolygonController : BaseGraphicController {
    private let polygonSymbol: AGSSimpleFillSymbol
    private let polygonStrokeSymbol: AGSSimpleLineSymbol


    init(polygonId: String) {
        polygonStrokeSymbol = AGSSimpleLineSymbol(style: .solid, color: UIColor.black, width: 10)
        polygonSymbol = AGSSimpleFillSymbol(style: .solid, color: UIColor.black, outline: polygonStrokeSymbol)
        super.init(graphics: AGSGraphic(geometry: nil, symbol: polygonSymbol, attributes: ["polygonId": polygonId]))
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

    func setPoints(points: [AGSPoint]) {
        graphics.geometry = AGSPolygon(points: points)
    }

    func setStrokeWidth(width: CGFloat) {
        polygonStrokeSymbol.width = width
    }

    func setZIndex(zIndex: Int) {
        graphics.zIndex = zIndex
    }

}