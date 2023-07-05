//
// Created by Valentin Grigorean on 26.06.2023.
//

import Foundation
import ArcGIS


extension TimeValue.Unit {
    init(_ flutterValue: Int) {
        switch flutterValue {
        case 1:
            self = .centuries
        case 2:
            self = .days
        case 3:
            self = .decades
        case 4:
            self = .hours
        case 5:
            self = .milliseconds
        case 6:
            self = .minutes
        case 7:
            self = .months
        case 8:
            self = .seconds
        case 9:
            self = .weeks
        case 10:
            self = .years
        default:
            fatalError("Unknown TimeValue.Unit value \(flutterValue)")
        }
    }

    func toFlutterValue() -> Int {
        switch self {
        case .centuries:
            return 1
        case .days:
            return 2
        case .decades:
            return 3
        case .hours:
            return 4
        case .milliseconds:
            return 5
        case .minutes:
            return 6
        case .months:
            return 7
        case .seconds:
            return 8
        case .weeks:
            return 9
        case .years:
            return 10
        }
    }

    static func fromFlutterValue(_ flutterValue: Int) -> TimeValue.Unit? {
        switch flutterValue {
        case 0:
            return nil
        case 1:
            return .centuries
        case 2:
            return .days
        case 3:
            return .decades
        case 4:
            return .hours
        case 5:
            return .milliseconds
        case 6:
            return .minutes
        case 7:
            return .months
        case 8:
            return .seconds
        case 9:
            return .weeks
        case 10:
            return .years
        default:
            fatalError("Unknown TimeValue.Unit value \(flutterValue)")
        }
    }
}

extension TileCache.StorageFormat {

    init?(_ flutterValue: Int) {
        switch flutterValue {
        case 0:
            self = .compact
        case 1:
            self = .compactV2
        case 2:
            self = .exploded
        default:
            return nil
        }
    }

    func toFlutterValue() -> Int {
        switch self {
        case .compact:
            return 0
        case .compactV2:
            return 1
        case .exploded:
            return 2
        default:
            return -1
        }
    }
}
