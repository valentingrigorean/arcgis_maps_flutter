//
// Created by Valentin Grigorean on 26.06.2023.
//

import Foundation
import ArcGIS

extension LabelingInfo.LabelPlacement {
    init(_ flutterValue: String) {
        switch flutterValue {
        case "automatic":
            self = .automatic
        case "lineAboveAfter":
            self = .lineAboveAfter
        case "lineAboveAlong":
            self = .lineAboveAlong
        case "lineAboveBefore":
            self = .lineAboveBefore
        case "lineAboveEnd":
            self = .lineAboveEnd
        case "lineAboveStart":
            self = .lineAboveStart
        case "lineBelowAfter":
            self = .lineBelowAfter
        case "lineBelowAlong":
            self = .lineBelowAlong
        case "lineBelowBefore":
            self = .lineBelowBefore
        case "lineBelowEnd":
            self = .lineBelowEnd
        case "lineBelowStart":
            self = .lineBelowStart
        case "lineCenterAfter":
            self = .lineCenterAfter
        case "lineCenterAlong":
            self = .lineCenterAlong
        case "lineCenterBefore":
            self = .lineCenterBefore
        case "lineCenterEnd":
            self = .lineCenterEnd
        case "lineCenterStart":
            self = .lineCenterStart
        case "pointAboveCenter":
            self = .pointAboveCenter
        case "pointAboveLeft":
            self = .pointAboveLeft
        case "pointAboveRight":
            self = .pointAboveRight
        case "pointBelowCenter":
            self = .pointBelowCenter
        case "pointBelowLeft":
            self = .pointBelowLeft
        case "pointBelowRight":
            self = .pointBelowRight
        case "pointCenterCenter":
            self = .pointCenterCenter
        case "pointCenterLeft":
            self = .pointCenterLeft
        case "pointCenterRight":
            self = .pointCenterRight
        case "polygonAlwaysHorizontal":
            self = .polygonAlwaysHorizontal
        default:
            fatalError("Invalid LabelPlacement value \(flutterValue)")
        }
    }
}

extension LabelDefinition {
    convenience init(data: [String: Any]) {
        let labelExpression = parseLabelExpression(data: data["labelExpression"] as! [String: Any])

        let textSymbol = SymbolFactory.createSymbol(data: data["symbol"]) as? TextSymbol
        self.init(labelExpression: labelExpression, textSymbol: textSymbol)
        if let labelPlacement = data["placement"] as? String {
            self.placement = LabelingInfo.LabelPlacement(labelPlacement)
        }
        if let minScale = data["minScale"] as? Double {
            self.minScale = minScale
        }
        if let maxScale = data["maxScale"] as? Double {
            self.maxScale = maxScale
        }
    }


   
}


private func parseLabelExpression(data: [String: Any]) -> LabelExpression {
    let expression = data["expression"] as! String
    switch data["type"] as! String {
    case "arcade":
        return ArcadeLabelExpression(arcadeString: expression)
    case "simple":
        return SimpleLabelExpression(simpleExpression: expression)
    default:
        fatalError("Invalid LabelExpression type \(data["type"] as! String)")
    }
}
