//
// Created by Valentin Grigorean on 11.07.2021.
//

import Foundation
import ArcGIS

public func toScalebarAlignment(rawValue: Int) -> ScalebarAlignment {
    switch rawValue {
    case 0:
        return .left
    case 1:
        return .right
    case 2:
        return .center
    default:
        fatalError("Invalid ScalebarAlignment type \(rawValue)")
    }
}

public func toScalebarStyle(rawValue: Int) -> ScalebarStyle {
    switch rawValue {
    case 0:
        return .line
    case 1:
        return .bar
    case 2:
        return .graduatedLine
    case 3:
        return .alternatingBar
    case 4:
        return .dualUnitLine
    case 5:
        return .dualUnitLineNauticalMile
    default:
        fatalError("Invalid ScalebarStyle type \(rawValue)")
    }
}

public func toScalebarUnits(rawValue: Int) -> ScalebarUnits {
    switch rawValue {
    case 0:
        return .imperial
    case 1:
        return .metric
    default:
        fatalError("Invalid ScalebarUnits type \(rawValue)")
    }
}