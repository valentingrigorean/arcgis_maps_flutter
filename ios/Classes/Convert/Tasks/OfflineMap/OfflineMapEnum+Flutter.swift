//
//  OfflineMapEnum+Flutter.swift
//  arcgis_maps_flutter
//
//  Created by Valentin Grigorean on 05.05.2023.
//

import Foundation
import ArcGIS


extension GenerateOfflineMapParameters.OnlineOnlyServicesOption {

    init(_ flutterValue: Int) {
        switch flutterValue {
        case 0:
            self = .exclude
        case 1:
            self = .include
        case 2:
            self = .useAuthoredSettings
        default:
            fatalError("Unexpected value: \(flutterValue)")
        }
    }

    func toFlutterValue() -> Int {
        switch self {
        case .exclude:
            return 0
        case .include:
            return 1
        case .useAuthoredSettings:
            return 2
        default:
            fatalError("Unexpected value: \(self)")
        }
    }


}

extension ReturnLayerAttachmentOption {
    init(_ flutterValue: Int) {
        switch flutterValue {
        case 0:
            self = .notIncluded
        case 1:
            self = .allLayers
        case 2:
            self = .readOnlyLayers
        case 3:
            self = .editableLayers
        default:
            fatalError("Unexpected value: \(flutterValue)")
        }
    }

    func toFlutterValue() -> Int {
        switch self {
        case .notIncluded:
            return 0
        case .allLayers:
            return 1
        case .readOnlyLayers:
            return 2
        case .editableLayers:
            return 3
        default:
            fatalError("Unexpected value: \(self)")
        }
    }


}

extension DownloadPreplannedOfflineMapParameters.UpdateMode {
    init(_ flutterValue: Int) {
        switch flutterValue {
        case 0:
            self = .syncWithFeatureServices
        case 1:
            self = .noUpdates
        default:
            fatalError("Unexpected value: \(flutterValue)")
        }
    }

    func toFlutterValue() -> Int {
        switch self {
        case .syncWithFeatureServices:
            return 0
        case .noUpdates:
            return 1
        default:
            fatalError("Unexpected value: \(self)")
        }
    }
}

extension GenerateOfflineMapParameters.DestinationTableRowFilter {
    init(_ flutterValue: Int) {
        switch flutterValue {
        case 0:
            self = .all
        case 1:
            self = .relatedOnly
        default:
            fatalError("Unexpected value: \(flutterValue)")
        }
    }

    func toFlutterValue() -> Int {
        switch self {
        case .all:
            return 0
        case .relatedOnly:
            return 1
        default:
            fatalError("Unexpected value: \(self)")
        }
    }

}

extension OfflineMapSyncParameters.PreplannedScheduledUpdatesOption {

    init(_ flutterValue: Int) {
        switch flutterValue {
        case 0:
            self = .noUpdates
        case 1:
            self = .downloadAllUpdates
        default:
            fatalError("Unexpected value: \(flutterValue)")
        }
    }

    func toFlutterValue() -> Int {
        switch self {
        case .noUpdates:
            return 0
        case .downloadAllUpdates:
            return 1
        default:
            fatalError("Unexpected value: \(self)")
        }
    }
}

extension GenerateOfflineMapParameters.UpdateMode {
    init(_ flutterValue: Int) {
        switch flutterValue {
        case 0:
            self = .syncWithFeatureServices
        case 1:
            self = .noUpdates
        default:
            fatalError("Unexpected value: \(flutterValue)")
        }
    }

    func toFlutterValue() -> Int {
        switch self {
        case .syncWithFeatureServices:
            return 0
        case .noUpdates:
            return 1
        default:
            fatalError("Unexpected value: \(self)")
        }
    }
}

extension OfflineMapUpdatesInfo.Availability {

    init(_ flutterValue: Int) {
        switch flutterValue {
        case -1:
            self = .indeterminate
        case 0:
            self = .available
        case 1:
            self = .noneAvailable
        default:
            fatalError("Unexpected value: \(flutterValue)")
        }
    }

    func toFlutterValue() -> Int {
        switch self {
        case .indeterminate:
            return -1
        case .available:
            return 0
        case .noneAvailable:
            return 1
        default:
            fatalError("Unexpected value: \(self)")
        }
    }
}
