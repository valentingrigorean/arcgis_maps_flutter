//
// Created by Valentin Grigorean on 18.04.2024.
//

import Foundation
import ArcGIS

extension SimpleFillSymbol.Style{
    init(_ flutterValue: String) {
        switch flutterValue {
        case "backwardDiagonal":
            self = .backwardDiagonal
            break
        case "cross":
            self = .cross
            break
        case "diagonalCross":
            self = .diagonalCross
            break
        case "forwardDiagonal":
            self = .forwardDiagonal
            break
        case "horizontal":
            self = .horizontal
            break
        case "none":
            self = .noFill
            break
        case "solid":
            self = .solid
            break
        case "vertical":
            self = .vertical
            break
        default:
            fatalError("Invalid SimpleFillSymbol.Style value \(flutterValue)")
        }    }
}


extension SimpleFillSymbol{
    func interpretSimpleFillSymbol(data:Dictionary<String, Any>){
        if let outline = data["outline"] as? Dictionary<String, Any> {
            let outlineSymbol = SimpleLineSymbol()
            outlineSymbol.interpretSimpleLineSymbol(data: outline)
            self.outline = outlineSymbol
        }

        if let style = data["style"] as? String {
            self.style = SimpleFillSymbol.Style(style)
        }

        if let color = data["color"] {
            self.color = UIColor(data: color)!
        }
    }
}
