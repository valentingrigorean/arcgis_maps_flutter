//
// Created by Valentin Grigorean on 29.03.2021.
//

import Foundation
import ArcGIS

class MarkerController {
    private let graphics: AGSGraphic
    private var marker: AGSCompositeSymbol
    private var icon: BitmapDescriptor?
    private var iconSymbol: AGSSymbol?
    private var backgroundImage: BitmapDescriptor?
    private var backgroundImageSymbol: AGSSymbol?
    private weak var graphicsOverlay: AGSGraphicsOverlay?

    private var iconOffsetX: CGFloat = 0
    private var iconOffsetY: CGFloat = 0

    private var opacity: Float = 1

    var isSelected: Bool = false {
        didSet {
            if oldValue != isSelected {
                graphics.isSelected = isSelected
            }
        }
    }

    var consumeTabEvent = false

    init(graphicsOverlay: AGSGraphicsOverlay,
         markerId: String) {
        self.graphicsOverlay = graphicsOverlay
        marker = AGSCompositeSymbol()
        graphics = AGSGraphic(geometry: nil, symbol: marker, attributes: ["markerId": markerId])
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

    func setIcon(bitmapDescription: BitmapDescriptor) {
        if icon == bitmapDescription {
            return
        }
        if icon != nil {
            marker.symbols.remove(at: backgroundImage == nil ? 0 : 1)
        }
        icon = bitmapDescription
        iconSymbol = createSymbol(bitmapDescription: bitmapDescription)
        offsetSymbol(symbol: iconSymbol!, offsetX: iconOffsetX, offsetY: iconOffsetY)
        marker.symbols.insert(iconSymbol!, at: backgroundImage == nil ? 0 : 1)

    }

    func setBackground(bitmapDescription: BitmapDescriptor) {
        if backgroundImage == bitmapDescription {
            return
        }
        if backgroundImage != nil {
            marker.symbols.remove(at: 0)
        }

        backgroundImage = bitmapDescription

        backgroundImageSymbol = createSymbol(bitmapDescription: bitmapDescription)
        marker.symbols.insert(backgroundImageSymbol!, at: 0)
    }

    func setPosition(location: AGSPoint) {
        graphics.geometry = location
    }

    func setIconOffset(offsetX: CGFloat,
                       offsetY: CGFloat) {
        if offsetX == iconOffsetX && offsetY == iconOffsetY {
            return
        }
        iconOffsetX = offsetX
        iconOffsetY = offsetY

        if icon != nil {
            guard  let symbol = marker.symbols.last as? AGSMarkerSymbol else {
                return
            }
            offsetSymbol(symbol: symbol, offsetX: offsetX, offsetY: offsetY)
        }
    }

    func setOpacity(opacity: Float) {
        self.opacity = opacity
        setGraphicsOpacity(opacity: opacity)
    }

    func setZIndex(zIndex: Int) {
        graphics.zIndex = zIndex
    }

    private func offsetSymbol(symbol: AGSSymbol,
                              offsetX: CGFloat,
                              offsetY: CGFloat) {
        guard let markerSymbol = symbol as? AGSMarkerSymbol else {
            return
        }

        markerSymbol.offsetX = offsetX
        markerSymbol.offsetY = offsetY
    }

    private func setGraphicsOpacity(opacity: Float) {
        for symbol in marker.symbols {
            if let markerSymbol = symbol as? AGSPictureMarkerSymbol {
                markerSymbol.opacity = opacity
            }
        }
    }



    private func createSymbol(bitmapDescription: BitmapDescriptor) -> AGSSymbol {
        let newSymbol = bitmapDescription.createSymbol()
        setOpacity(opacity: opacity)
        return newSymbol
    }

    private func setOpacity(symbol: AGSSymbol,opacity:Float){
        guard let pictureSymbol = symbol as? AGSPictureMarkerSymbol else {
            return
        }
        pictureSymbol.opacity = opacity
    }

    private func setSymbolSize(symbol: AGSSymbol,
                               width: CGFloat,
                               height: CGFloat) {
        guard let pictureSymbol = symbol as? AGSPictureMarkerSymbol else {
            return
        }
        pictureSymbol.width = width
        pictureSymbol.height = height
    }
}
