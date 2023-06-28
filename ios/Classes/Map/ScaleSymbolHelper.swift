//
// Created by Valentin Grigorean on 06.07.2021.
//

import Foundation
import ArcGIS

class ScaleSymbolHelper {
    private let scaleSymbols: [SymbolScaleHandler]

    let symbol: Symbol

    init(symbol: Symbol) {
        self.symbol = symbol
        scaleSymbols = ScaleSymbolHelper.populateDefaultSize(symbol: symbol)
    }

    func setScale(scale: CGFloat) {
        for scaleSymbol in scaleSymbols {
            scaleSymbol.setScale(newScale: scale)
        }
    }

    private static func populateDefaultSize(symbol: Symbol) -> [SymbolScaleHandler] {
        var arr = Array<SymbolScaleHandler>()
        if let compositeSymbol = symbol as? CompositeSymbol {
            for child in compositeSymbol.symbols {
                arr.append(contentsOf: populateDefaultSize(symbol: child))
            }
        } else {
            arr.append(SymbolScaleHandler(symbol: symbol))
        }

        return arr
    }

}

fileprivate class SymbolScaleHandler {
    private let symbol: Symbol
    private let haveSize: Bool
    private let width: CGFloat
    private let height: CGFloat

    private var scale: CGFloat = 1

    init(symbol: Symbol) {
        self.symbol = symbol
        if let pictureMarkerSymbol = symbol as? PictureMarkerSymbol {
            haveSize = true
            width = pictureMarkerSymbol.width
            height = pictureMarkerSymbol.height
        } else if let pictureFillSymbol = symbol as? PictureFillSymbol {
            haveSize = true
            width = pictureFillSymbol.width
            height = pictureFillSymbol.height
        } else {
            haveSize = false
            width = 0
            height = 0
        }
    }

    func setScale(newScale: CGFloat) {
        if !haveSize {
            return
        }
        if newScale == scale {
            return
        }

        scale = newScale
        let newWidth = width * newScale
        let newHeight = height * newScale
        if let pictureMarkerSymbol = symbol as? PictureMarkerSymbol {
            pictureMarkerSymbol.width = newWidth
            pictureMarkerSymbol.height = newHeight
        } else if let pictureFillSymbol = symbol as? PictureFillSymbol {
            pictureFillSymbol.width = newWidth
            pictureFillSymbol.height = newHeight
        }
    }
}