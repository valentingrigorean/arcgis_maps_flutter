//
// Created by Valentin Grigorean on 29.03.2021.
//

import Foundation
import ArcGIS

class MarkerController: BaseGraphicController {
    private var marker: AGSCompositeSymbol
    private var icon: BitmapDescriptor?
    private var iconSymbol: ScaleSymbolHelper?
    private var backgroundImage: BitmapDescriptor?
    private var backgroundImageSymbol: ScaleSymbolHelper?

    private var iconOffsetX: CGFloat = 0
    private var iconOffsetY: CGFloat = 0

    private var opacity: Float = 1

    private var selected: Bool = false

    private var selectedScale: CGFloat = 1.4

    private var angle: Float = 0.0

    init(markerId: String,
         selectionPropertiesHandler: SelectionPropertiesHandler) {
        marker = AGSCompositeSymbol()
        super.init(graphics: AGSGraphic(geometry: nil, symbol: marker, attributes: ["markerId": markerId]), selectionPropertiesHandler: selectionPropertiesHandler)
    }

    override var isSelected: Bool {
        get {
            selected
        }
        set {
            if selected != newValue {
                selected = newValue
                handleScaleChanged()
            }
        }
    }

    func setIcon(bitmapDescription: BitmapDescriptor) {
        if icon == bitmapDescription {
            return
        }
        if icon != nil {
            marker.symbols.remove(at: backgroundImage == nil ? 0 : 1)
        }
        icon = bitmapDescription
        iconSymbol = ScaleSymbolHelper(symbol: createSymbol(bitmapDescription: bitmapDescription))
        offsetSymbol(symbol: iconSymbol!.symbol, offsetX: iconOffsetX, offsetY: iconOffsetY)
        marker.symbols.insert(iconSymbol!.symbol, at: backgroundImage == nil ? 0 : 1)
        updateCommonProps()
    }

    func setBackground(bitmapDescription: BitmapDescriptor) {
        if backgroundImage == bitmapDescription {
            return
        }
        if backgroundImage != nil {
            marker.symbols.remove(at: 0)
        }

        backgroundImage = bitmapDescription
        backgroundImageSymbol = ScaleSymbolHelper(symbol: createSymbol(bitmapDescription: bitmapDescription))
        marker.symbols.insert(backgroundImageSymbol!.symbol, at: 0)
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

    func setAngle(angle: Float) {
        if self.angle == angle {
            return
        }
        self.angle = angle
        setGraphicsAngle(angle: angle)
    }

    func setSelectedScale(selectedScale: CGFloat) {
        if selectedScale == selectedScale {
            return
        }
        self.selectedScale = selectedScale
        handleScaleChanged()
    }

    private func updateCommonProps() {
        handleScaleChanged()
        setGraphicsAngle(angle: angle)
        setGraphicsOpacity(opacity: opacity)
    }

    private func handleScaleChanged() {

        let scale = isSelected ? selectedScale : 1.0

        if let iconSymbol = iconSymbol {
            iconSymbol.setScale(scale: scale)
        }

        if let backgroundImageSymbol = backgroundImageSymbol {
            backgroundImageSymbol.setScale(scale: scale)
        }
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

    private func setGraphicsAngle(angle: Float) {
        for symbol in marker.symbols {
            if let markerSymbol = symbol as? AGSMarkerSymbol {
                markerSymbol.angle = angle
            }
        }
    }

    private func createSymbol(bitmapDescription: BitmapDescriptor) -> AGSSymbol {
        let newSymbol = bitmapDescription.createSymbol()
        setOpacity(opacity: opacity)
        return newSymbol
    }

    private func setOpacity(symbol: AGSSymbol,
                            opacity: Float) {
        guard let pictureSymbol = symbol as? AGSPictureMarkerSymbol else {
            return
        }
        pictureSymbol.opacity = opacity
    }
}
