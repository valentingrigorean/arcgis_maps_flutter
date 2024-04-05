//
// Created by Valentin Grigorean on 29.03.2021.
//

import Foundation
import ArcGIS

class MarkerController: BaseGraphicController {
    private var marker: CompositeSymbol
    private var icon: BitmapDescriptor?
    private var iconSymbol: Symbol?
    private var backgroundImage: BitmapDescriptor?
    private var backgroundImageSymbol: Symbol?
    private var textSymbol: TextSymbol?

    private var iconOffsetX: CGFloat = 0
    private var iconOffsetY: CGFloat = 0

    private var opacity: Float = 1

    private var selected: Bool = false

    private var selectedScale: CGFloat = 1.4

    private var angle: Float = 0.0

    init(markerId: String) {
        marker = CompositeSymbol()
        super.init(graphics: Graphic(geometry: nil, attributes: ["markerId": markerId], symbol: marker))
    }

    override var isSelected: Bool {
        get {
            selected
        }
        set {
            if selected != newValue {
                selected = newValue
            }
        }
    }

    func setIcon(bitmapDescription: BitmapDescriptor) {
        if icon == bitmapDescription {
            return
        }
        if icon != nil {
            let symbolIndex = backgroundImage == nil ? 0 : 1
            marker.removeSymbol(marker.symbols[symbolIndex])
        }
        icon = bitmapDescription
        iconSymbol = createSymbol(bitmapDescription: bitmapDescription)
        offsetSymbol(symbol: iconSymbol!, offsetX: iconOffsetX, offsetY: iconOffsetY)
        marker.insertSymbol(iconSymbol!, at: backgroundImage == nil ? 0 : 1)
        updateCommonProps()
    }

    func setBackground(bitmapDescription: BitmapDescriptor) {
        if backgroundImage == bitmapDescription {
            return
        }
        if backgroundImage != nil {
            let symbolIndex = icon == nil ? 0 : 1
            marker.removeSymbol(marker.symbols[symbolIndex])
        }

        backgroundImage = bitmapDescription
        backgroundImageSymbol = createSymbol(bitmapDescription: bitmapDescription)
        marker.insertSymbol(backgroundImageSymbol!, at: 0)
        updateCommonProps()
    }


    func setIconOffset(offsetX: CGFloat,
                       offsetY: CGFloat) {
        if offsetX == iconOffsetX && offsetY == iconOffsetY {
            return
        }
        iconOffsetX = offsetX
        iconOffsetY = offsetY

        if icon != nil {
            guard let symbol = marker.symbols.last as? MarkerSymbol else {
                return
            }
            offsetSymbol(symbol: symbol, offsetX: offsetX, offsetY: offsetY)
        }
    }

    func setOpacity(opacity: Float) {
        self.opacity = opacity
        setGraphicsOpacity(opacity: opacity)
    }

    func setAngle(angle: Float) {
        if self.angle == angle {
            return
        }
        self.angle = angle
        setGraphicsAngle(angle: angle)
    }


    func setTextSymbol(data: [String: Any]?) {
        if let textSymbolData = data {
            if textSymbol == nil {
                textSymbol = TextSymbol()
                marker.addSymbol(textSymbol!)
            }
            textSymbol?.interpretTextSymbol(data: textSymbolData)
        } else {
            if textSymbol != nil {
                marker.removeSymbol(textSymbol!)
                textSymbol = nil
            }
        }
    }



    private func updateCommonProps() {
        setGraphicsAngle(angle: angle)
        setGraphicsOpacity(opacity: opacity)
    }


    private func offsetSymbol(symbol: Symbol,
                              offsetX: CGFloat,
                              offsetY: CGFloat) {
        guard let markerSymbol = symbol as? MarkerSymbol else {
            return
        }

        markerSymbol.offsetX = offsetX
        markerSymbol.offsetY = offsetY
    }

    private func setGraphicsOpacity(opacity: Float) {
        for symbol in marker.symbols {
            if let markerSymbol = symbol as? PictureMarkerSymbol {
                markerSymbol.opacity = opacity
            }
        }
    }

    private func setGraphicsAngle(angle: Float) {
        for symbol in marker.symbols {
            if let markerSymbol = symbol as? MarkerSymbol {
                markerSymbol.angle = angle
                markerSymbol.angleAlignment = angle == 0 ? .screen : .map
            }
        }
    }

    private func createSymbol(bitmapDescription: BitmapDescriptor) -> Symbol {
        let newSymbol = bitmapDescription.createSymbol()
        setOpacity(opacity: opacity)
        return newSymbol
    }

    private func setOpacity(symbol: Symbol,
                            opacity: Float) {
        guard let pictureSymbol = symbol as? PictureMarkerSymbol else {
            return
        }
        pictureSymbol.opacity = opacity
    }
}
