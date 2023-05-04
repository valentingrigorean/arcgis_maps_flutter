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

extension UnitSystem {
    func toFlutterValue()->Int{
        switch self{
        case .imperial:
            return 0
        case .metric:
            return 1
        @unknown default:
            <#fatalError()#>        
        }
    }
    
    static func fromFlutter(_ flutterValue: Int) -> UnitSystem{
        switch flutterValue{
        case 0:
            return UnitSystem.imperial
        case 1:
            return UnitSystem.metric
        }
    }
}

extension LinearUnit.ID {
    static func fromFlutter(_ index: Int) -> LinearUnit.ID {
        switch index {
        case 0:
            return .centimeters
        case 1:
            return .feet
        case 2:
            return .inches
        case 3:
            return .kilometers
        case 4:
            return .meters
        case 5:
            return .miles
        case 6:
            return .nauticalMiles
        case 7:
            return .yards
        default:
            return .other
        }
    }

    func toFlutter() -> Int {
        switch self {
        case .centimeters:
            return 0
        case .feet:
            return 1
        case .inches:
            return 2
        case .kilometers:
            return 3
        case .meters:
            return 4
        case .miles:
            return 5
        case .nauticalMiles:
            return 6
        case .yards:
            return 7
        default:
            return 8
        }
    }
}


extension AngularUnitID {

    static func fromFlutter(_ index: Int) -> AGSAngularUnitID {
        switch index {
        case 0:
            return .degrees
        case 1:
            return .minutes
        case 2:
            return .seconds
        case 3:
            return .grads
        case 4:
            return .radians
        default:
            return .other
        }
    }

    func toFlutter() -> Int {
        switch self {
        case .degrees:
            return 0
        case .minutes:
            return 1
        case .seconds:
            return 2
        case .grads:
            return 3
        case .radians:
            return 4
        case .other:
            return 5
        default:
            return -1
        }
    }
}

extension AGSAreaUnitID {
    
    static func fromFlutter(_ index: Int) -> AGSAreaUnitID {
        switch index {
        case 0:
            return .acres
        case 1:
            return .hectares
        case 2:
            return .squareCentimeters
        case 3:
            return .squareDecimeters
        case 4:
            return .squareFeet
        case 5:
            return .squareMeters
        case 6:
            return .squareKilometers
        case 7:
            return .squareMiles
        case 8:
            return .squareMillimeters
        case 9:
            return .squareYards
        default:
            return .other
        }
    }
}

extension AGSSpatialRelationship {

    static func fromFlutter(_ index: Int) -> AGSSpatialRelationship {
        switch index {
        case -1:
            return .unknown
        case 0:
            return .relate
        case 1:
            return .equals
        case 2:
            return .disjoint
        case 3:
            return .intersects
        case 4:
            return .touches
        case 5:
            return .crosses
        case 6:
            return .within
        case 7:
            return .contains
        case 8:
            return .overlaps
        case 9:
            return .envelopeIntersects
        case 10:
            return .indexIntersects
        default:
            return .unknown
        }
    }

    func toFlutter() -> Int {
        switch self {
        case .unknown:
            return -1
        case .relate:
            return 0
        case .equals:
            return 1
        case .disjoint:
            return 2
        case .intersects:
            return 3
        case .touches:
            return 4
        case .crosses:
            return 5
        case .within:
            return 6
        case .contains:
            return 7
        case .overlaps:
            return 8
        case .envelopeIntersects:
            return 9
        case .indexIntersects:
            return 10
        default:
            return -1
        }
    }
}

extension StatisticType {
    static func fromFlutter(_ value: String?) -> StatisticType{
        var staticType: AGSStatisticType = AGSStatisticType.sum

        switch (value) {

        case "AVERAGE":
            staticType = AGSStatisticType.average
            break

        case "COUNT":
            staticType = AGSStatisticType.count
            break
        case "MAXIMUM":
            staticType = AGSStatisticType.maximum
            break
        case "MINIMUM":
            staticType = AGSStatisticType.minimum
            break
        case "STANDARD_DEVIATION":
            staticType = AGSStatisticType.standardDeviation
            break
        case "SUM":
            staticType = AGSStatisticType.sum
            break
        case "VARIANCE":
            staticType = AGSStatisticType.variance
            break
        default:
            staticType = AGSStatisticType.sum
            break
        }

        return staticType
    }
}
