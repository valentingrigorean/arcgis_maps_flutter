//
// Created by Valentin Grigorean on 28.04.2021.
//

import Foundation
import ArcGIS

class PolylineController {
    private let graphics: AGSGraphic
    private let polylineSymbol: AGSSimpleLineSymbol

    private weak var graphicsOverlay: AGSGraphicsOverlay?

    var consumeTabEvent = false

    init(graphicsOverlay: AGSGraphicsOverlay,
         polylineId: String) {
        self.graphicsOverlay = graphicsOverlay
        polylineSymbol = AGSSimpleLineSymbol(style: .solid, color: UIColor.black, width: 10)
        graphics = AGSGraphic(geometry: nil, symbol: polylineSymbol, attributes: ["polylineId": polylineId])
    }

    func add() {
        guard let graphicsOverlay = graphicsOverlay else {
            return
        }
        graphicsOverlay.graphics.add(graphics)
    }

    func remove() {
        guard let graphicsOverlay = graphicsOverlay else {
            return
        }

        graphicsOverlay.graphics.remove(graphics)
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