//
// Created by Valentin Grigorean on 04.04.2024.
//

import Foundation
import ArcGIS

extension TextSymbol.FontStyle {
    init(name: String) {
        switch name {
        case "italic":
            self = .italic
        case "normal":
            self = .normal
        case "oblique":
            self = .oblique
        default:
            fatalError("Invalid TextSymbol.FontStyle type \(name)")
        }
    }
}

extension TextSymbol.FontWeight {
    init(name: String) {
        switch name {
        case "bold":
            self = .bold
        case "normal":
            self = .normal
        default:
            fatalError("Invalid TextSymbol.FontWeight type \(name)")
        }
    }
}

extension TextSymbol.HorizontalAlignment {
    init(name: String) {
        switch name {
        case "center":
            self = .center
        case "justify":
            self = .justify
        case "left":
            self = .left
        case "right":
            self = .right
        default:
            fatalError("Invalid TextSymbol.HorizontalAlignment type \(name)")
        }
    }
}

extension TextSymbol.VerticalAlignment {
    init(name: String) {
        switch name {
        case "baseline":
            self = .baseline
        case "bottom":
            self = .bottom
        case "middle":
            self = .middle
        case "top":
            self = .top
        default:
            fatalError("Invalid TextSymbol.VerticalAlignment type \(name)")
        }
    }
}


extension TextSymbol {
    func interpretTextSymbol(data: Dictionary<String, Any>) {
        interpretMarkerSymbol(data: data)
        if let text = data["text"] as? String {
            self.text = text
        }
        if let size = data["size"] as? Double {
            self.size = CGFloat(size)
        }
        if let color = data["color"] {
            self.color = UIColor(data: color)!
        }
        if let fontFamily = data["fontFamily"] as? String {
            self.fontFamily = fontFamily
        }
        if let fontStyle = data["fontStyle"] as? String {
            self.fontStyle = TextSymbol.FontStyle(name: fontStyle)
        }
        if let fontWeight = data["fontWeight"] as? String {
            self.fontWeight = TextSymbol.FontWeight(name: fontWeight)
        }
        if let haloColor = data["haloColor"] {
            self.haloColor = UIColor(data: haloColor)!
        }
        if let haloWidth = data["haloWidth"] as? Double {
            self.haloWidth = CGFloat(haloWidth)
        }
        if let horizontalAlignment = data["horizontalAlignment"] as? String {
            self.horizontalAlignment = TextSymbol.HorizontalAlignment(name: horizontalAlignment)
        }
        if let verticalAlignment = data["verticalAlignment"] as? String {
            self.verticalAlignment = TextSymbol.VerticalAlignment(name: verticalAlignment)
        }
    }
}
