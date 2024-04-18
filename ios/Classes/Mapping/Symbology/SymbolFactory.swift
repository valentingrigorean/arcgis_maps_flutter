//
// Created by Valentin Grigorean on 18.04.2024.
//

import Foundation
import ArcGIS

class SymbolFactory {
    static func createSymbol(data: Any?) -> Symbol? {
        guard let data = data as? Dictionary<String, Any> else {
            return nil
        }

        guard let type = data["type"] as? String else {
            return nil
        }
        switch type {
        case "simple-marker":
            let simpleMarker = SimpleMarkerSymbol()
            simpleMarker.interpretSimpleMarkerSymbol(data: data)
            return simpleMarker
        case "simple-line":
            let simpleLine = SimpleLineSymbol()
            simpleLine.interpretLineSymbol(data: data)
            return simpleLine
        case "simple-fill":
            let simpleFill = SimpleFillSymbol()
            simpleFill.interpretSimpleFillSymbol(data: data)
            return simpleFill
        case "picture-marker":
            return createPictureMarkerSymbol(data: data)
        case "text":
            let textSymbol = TextSymbol()
            textSymbol.interpretTextSymbol(data: data)
            return textSymbol
        default:
            return nil
        }
    }

    private static func createPictureMarkerSymbol(data: Dictionary<String, Any>) -> PictureMarkerSymbol {
        var symbol: PictureMarkerSymbol
        if let url = data["url"] as? String {
            symbol = PictureMarkerSymbol(url: URL(string: url)!)
        } else if let resource = data["resource"] as? String {
            let tintColor = UIColor(data: data["tintColor"])
            var image = UIImage(named: resource)!
            if let color = tintColor {
                image = image.colored(color)
            }
            symbol = PictureMarkerSymbol(image: image)
        } else if let fromBytes = data["fromBytes"] as? FlutterStandardTypedData {
            symbol = PictureMarkerSymbol(image: UIImage(data: fromBytes.data)!)
        } else {
            symbol = PictureMarkerSymbol()
        }

        symbol.interpretPictureMarkerSymbol(data: data)
        return symbol
    }
}
