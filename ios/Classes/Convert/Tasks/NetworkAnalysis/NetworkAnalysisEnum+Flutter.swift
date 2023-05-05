//
//  NetworkAnalysisEnum+Flutter.swift
//  arcgis_maps_flutter
//
//  Created by Valentin Grigorean on 04.05.2023.
//

import Foundation
import ArcGIS


extension DirectionsStyle{
    func toFlutterValue() -> Int {
        switch self{
        case .desktop :
            return 0
        case .navigation:
            return 1
        case .campus:
            return 2
        default:
            fatalError("Unexpected value: $this")
        }
    }
    
    static func fromFlutter(_ flutterValue:Int) -> DirectionsStyle {
        switch flutterValue {
        case 0:
            return DirectionsStyle.desktop
        case 1:
            return DirectionsStyle.navigation
        case 2:
            return DirectionsStyle.campus
        default:
            fatalError("Unexpected value: $this")
        }
    }
}


extension RouteShapeType {
    func toFlutterValue() -> Int {
        switch self {
        case .straightLine:
            return 1
        case .trueShapeWithMeasures:
            return 2
        default:
            fatalError("Unexpected value: $this")
        }
    }
    
    static func fromFlutter(_ flutterValue: Int) -> RouteShapeType {
        switch flutterValue {
        case 1:
            return .straightLine
        case 2:
            return .trueShapeWithMeasures
        default:
            fatalError("Unexpected flutterValue: \(flutterValue)")
        }
    }
    
}

extension TravelMode.UTurnPolicy {
    func toFlutterValue() -> Int {
        switch self {
        case .notAllowed:
            return 0
        case .allowedAtDeadEnds:
            return 1
        case .allowedAtIntersections:
            return 2
        case .allowedAtDeadEndsAndIntersections:
            return 3
        default:
            fatalError("Unexpected value: $this")
        }
    }
    
    static func fromFlutter(_ flutterValue: Int) -> TravelMode.UTurnPolicy {
        switch flutterValue {
        case 0:
            return .notAllowed
        case 1:
            return .allowedAtDeadEnds
        case 2:
            return .allowedAtIntersections
        case 3:
            return .allowedAtDeadEndsAndIntersections
        default:
            fatalError("Unexpected value: \(flutterValue)")
        }
    }
}

extension CostAttribute.Unit {
    func toFlutterValue() -> Int {
        switch self {
        case .inches:
            return 1
        case .feet:
            return 2
        case .yards:
            return 3
        case .miles:
            return 4
        case .millimeters:
            return 5
        case .centimeters:
            return 6
        case .meters:
            return 7
        case .kilometers:
            return 8
        case .nauticalMiles:
            return 9
        case .decimalDegrees:
            return 10
        case .seconds:
            return 11
        case .minutes:
            return 12
        case .hours:
            return 13
        case .days:
            return 14
        case .decimeters:
            return 15
        default:
            fatalError("Unexpected value: \(self)")
        }
    }
    
    static func fromFlutter(_ flutterValue: Int) -> CostAttribute.Unit {
        switch flutterValue {
        case 1:
            return .inches
        case 2:
            return .feet
        case 3:
            return .yards
        case 4:
            return .miles
        case 5:
            return .millimeters
        case 6:
            return .centimeters
        case 7:
            return .meters
        case 8:
            return .kilometers
        case 9:
            return .nauticalMiles
        case 10:
            return .decimalDegrees
        case 11:
            return .seconds
        case 12:
            return .minutes
        case 13:
            return .hours
        case 14:
            return .days
        case 15:
            return .decimeters
        default:
            fatalError("Unexpected value: \(flutterValue)")
        }
    }
}

extension NetworkDirectionsSupport {
    func toFlutterValue() -> Int {
        switch self {
        case .unsupported:
            return 1
        case .supported:
            return 2
        @unknown default:
            fatalError("Unexpected value: \(self)")
        }
    }
}

extension Stop.Kind {
    func toFlutterValue() -> Int {
        switch self {
        case .stop:
            return 0
        case .waypoint:
            return 1
        case .restBreak:
            return 2
        @unknown default:
            fatalError("Unexpected value: \(self)")
        }
    }
    
    static func fromFlutter(_ flutterValue: Int)-> Stop.Kind {
        switch flutterValue {
        case 0:
            return .stop
        case 1:
            return .waypoint
        case 2:
            return .restBreak
        default:
            fatalError("Unexpected value: (flutterValue)")
        }
    }
}

extension CurbApproach {
    func toFlutterValue() -> Int {
        switch self {
        case .eitherSide:
            return 0
        case .leftSide:
            return 1
        case .rightSide:
            return 2
        case .noUTurn:
            return 3
        @unknown default:
            return -1
        }
    }
    
    static func fromFlutter(_ flutterValue: Int) -> CurbApproach {
        switch flutterValue {
        case 0:
            return .eitherSide
        case 1:
            return .leftSide
        case 2:
            return .rightSide
        case 3:
            return .noUTurn
        default:
            fatalError("Unexpected value: \(flutterValue)")
        }
    }
}

extension DirectionMessage.Kind {
    func toFlutterValue() -> Int {
        switch self {
        case .streetName:
            return 0
        case .alternativeName:
            return 1
        case .branch:
            return 2
        case .toward:
            return 3
        case .crossStreet:
            return 4
        case .exit:
            return 5
        default:
            fatalError("Unexpected value: \(self)")
        }
    }
}

extension DirectionManeuver.Kind {
    func toFlutterValue() -> Int {
        switch self {
        case .stop:
            return 0
        case .straight:
            return 1
        case .bearLeft:
            return 2
        case .bearRight:
            return 3
        case .turnLeft:
            return 4
        case .turnRight:
            return 5
        case .sharpLeft:
            return 6
        case .sharpRight:
            return 7
        case .uTurn:
            return 8
        case .ferry:
            return 9
        case .roundabout:
            return 10
        case .highwayMerge:
            return 11
        case .highwayExit:
            return 12
        case .highwayChange:
            return 13
        case .forkCenter:
            return 14
        case .forkLeft:
            return 15
        case .forkRight:
            return 16
        case .depart:
            return 17
        case .tripItem:
            return 18
        case .endOfFerry:
            return 19
        case .rampRight:
            return 20
        case .rampLeft:
            return 21
        case .turnLeftRight:
            return 22
        case .turnRightLeft:
            return 23
        case .turnRightRight:
            return 24
        case .turnLeftLeft:
            return 25
        case .pedestrianRamp:
            return 26
        case .elevator:
            return 27
        case .escalator:
            return 28
        case .stairs:
            return 29
        case .doorPassage:
            return 30
        default:
            return -1
        }
    }
}

extension LocationStatus{
    func toFlutterValue() -> Int {
        switch self{
        case .notLocated :
            return 0
        case .onClosest:
            return 1
        case .onClosestNotRestricted:
            return 2
        case .notReached:
            return 3
        @unknown default:
            fatalError("Unexpected value: \(self)")
        }
    }
}


