//
// Created by Valentin Grigorean on 26.06.2023.
//

import Foundation
import ArcGIS


extension TimeValue.Unit {
    func toFlutterValue() -> Int {
        switch self {
        case .unknown:
            return 0
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

extension CacheStorageFormat {
    func toFlutterValue() -> Int {
        switch self {
        case .unknown:
            return -1
        case .compact:
            return 0
        case .compactV2:
            return 1
        case .exploded:
            return 2
        }
    }

    static func fromFlutterValue(_ flutterValue: Int) -> CacheStorageFormat {
        switch flutterValue {
        case -1:
            return .unknown
        case 0:
            return .compact
        case 1:
            return .compactV2
        case 2:
            return .exploded
        default:
            return .unknown
        }
    }
}
