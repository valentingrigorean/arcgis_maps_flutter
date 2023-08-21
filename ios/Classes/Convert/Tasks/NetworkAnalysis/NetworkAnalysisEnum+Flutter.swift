//
//  NetworkAnalysisEnum+Flutter.swift
//  arcgis_maps_flutter
//
//  Created by Valentin Grigorean on 04.05.2023.
//

import Foundation
import ArcGIS


extension DirectionsStyle {
    init(_ flutterValue: Int) {
        switch flutterValue {
        case 0:
            self = DirectionsStyle.desktop
        case 1:
            self = DirectionsStyle.navigation
        case 2:
            self = DirectionsStyle.campus
        default:
            fatalError("Unexpected value: $this")
        }
    }

    func toFlutterValue() -> Int {
        switch self {
        case .desktop:
            return 0
        case .navigation:
            return 1
        case .campus:
            return 2
        default:
            fatalError("Unexpected value: $this")
        }
    }
}


extension RouteShapeType {
    init?(_ flutterValue: Int) {
        switch flutterValue {
        case 0:
            return nil
        case 1:
            self = .straightLine
        case 2:
            self = .trueShapeWithMeasures
        default:
            fatalError("Unexpected flutterValue: \(flutterValue)")
        }
    }

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
}

extension Optional where Wrapped == RouteShapeType {
    func toFlutterValue() -> Int {
        switch self {
        case .some(let routeShapeType):
            return routeShapeType.toFlutterValue()
        case .none:
            return 0
        }
    }
}

extension TravelMode.UTurnPolicy {
    init(_ flutterValue: Int) {
        switch flutterValue {
        case 0:
            self = .notAllowed
        case 1:
            self = .allowedAtDeadEnds
        case 2:
            self = .allowedAtIntersections
        case 3:
            self = .allowedAtDeadEndsAndIntersections
        default:
            fatalError("Unexpected value: \(flutterValue)")
        }
    }

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
}

extension CostAttribute.Unit {
    init?(_ flutterValue: Int) {
        switch flutterValue {
        case 0:
            return nil
        case 1:
            self = .inches
        case 2:
            self = .feet
        case 3:
            self = .yards
        case 4:
            self = .miles
        case 5:
            self = .millimeters
        case 6:
            self = .centimeters
        case 7:
            self = .meters
        case 8:
            self = .kilometers
        case 9:
            self = .nauticalMiles
        case 10:
            self = .decimalDegrees
        case 11:
            self = .seconds
        case 12:
            self = .minutes
        case 13:
            self = .hours
        case 14:
            self = .days
        case 15:
            self = .decimeters
        default:
            fatalError("Unexpected value: \(flutterValue)")
        }
    }

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
}

extension Optional where Wrapped == CostAttribute.Unit {
    func toFlutterValue() -> Int {
        switch self {
        case .some(let unit):
            return unit.toFlutterValue()
        case .none:
            return 0
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
        default:
            fatalError("Unexpected value: \(self)")
        }
    }
}

extension Optional where Wrapped == NetworkDirectionsSupport {
    func toFlutterValue() -> Int {
        switch self {
        case .some(let unit):
            return unit.toFlutterValue()
        case .none:
            return 0
        }
    }
}

extension Stop.Kind {
    init(_ flutterValue: Int) {
        switch flutterValue {
        case 0:
            self = .stop
        case 1:
            self = .waypoint
        case 2:
            self = .restBreak
        default:
            fatalError("Unexpected value: (flutterValue)")
        }
    }

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
}

extension CurbApproach {
    init?(_ flutterValue: Int) {
        switch flutterValue {
        case -1:
            return nil
        case 0:
            self = .eitherSide
        case 1:
            self = .leftSide
        case 2:
            self = .rightSide
        case 3:
            self = .noUTurn
        default:
            fatalError("Unexpected value: \(flutterValue)")
        }
    }

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
        default:
            fatalError("Unexpected value: \(self)")
        }
    }
}

extension Optional where Wrapped == CurbApproach {
    func toFlutterValue() -> Int {
        switch self {
        case .some(let unit):
            return unit.toFlutterValue()
        case .none:
            return -1
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
            fatalError("Unexpected value: \(self)")
        }
    }
}

extension Optional where Wrapped == DirectionManeuver.Kind {
    func toFlutterValue() -> Int {
        switch self {
        case .some(let unit):
            return unit.toFlutterValue()
        case .none:
            return -1
        }
    }
}

extension LocationStatus {
    func toFlutterValue() -> Int {
        switch self {
        case .notLocated:
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


