//
//  TaskEnumConvert.swift
//  arcgis_maps_flutter
//
//  Created by Valentin Grigorean on 01.05.2023.
//

import Foundation
import ArcGIS

extension Job.Status{
    func toFlutterValue() -> Int{
        switch self{
        case .notStarted:
            return 0
        case .started:
            return 1
        case .paused:
            return 2
        case .succeeded:
            return 3
        case .failed:
            return 4
        case .canceling:
            return 5
        default:
            fatalError("Invalid Job.Status type \(self)")
        }
    }
}

extension JobMessage.Severity{
    func toFlutterValue() -> Int {
        switch self{
        case .info:
            return 0
        case .warning:
            return 1
        case .error:
            return 2
        default:
            return -1
        }
    }
}

extension JobMessage.Source{
    func toFlutterValue() -> Int{
        switch self{
        case .client:
            return 0
        case .service:
            return 1
        default:
            fatalError("Invalid JobMessage.Source type \(self)")
        }
    }
}
