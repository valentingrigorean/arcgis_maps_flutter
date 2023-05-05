//
//  OfflineMapEnum+Flutter.swift
//  arcgis_maps_flutter
//
//  Created by Valentin Grigorean on 05.05.2023.
//

import Foundation
import ArcGIS


extension GenerateOfflineMapParameters.OnlineOnlyServicesOption {
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
    
    static func fromFlutter(_ flutterValue: Int) -> GenerateOfflineMapParameters.OnlineOnlyServicesOption {
        switch flutterValue {
        case 0:
            return .exclude
        case 1:
            return .include
        case 2:
            return .useAuthoredSettings
        default:
            fatalError("Unexpected value: \(flutterValue)")
        }
    }
}

extension ReturnLayerAttachmentOption {
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
    
    static func fromFlutter(_ flutterValue: Int) -> ReturnLayerAttachmentOption {
        switch flutterValue {
        case 0:
            return .notIncluded
        case 1:
            return .allLayers
        case 2:
            return .readOnlyLayers
        case 3:
            return .editableLayers
        default:
            fatalError("Unexpected value: \(flutterValue)")
        }
    }
}

extension DownloadPreplannedOfflineMapParameters.UpdateMode {
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
    
    static func fromFlutter(_ flutterValue: Int) -> DownloadPreplannedOfflineMapParameters.UpdateMode {
        switch flutterValue {
        case 0:
            return .syncWithFeatureServices
        case 1:
            return .noUpdates
        default:
            fatalError("Unexpected value: \(flutterValue)")
        }
    }
}

extension GenerateOfflineMapParameters.DestinationTableRowFilter {
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
    
    static func fromFlutter(_ flutterValue: Int) -> GenerateOfflineMapParameters.DestinationTableRowFilter {
        switch flutterValue {
        case 0:
            return .all
        case 1:
            return .relatedOnly
        default:
            fatalError("Unexpected value: \(flutterValue)")
        }
    }
}

extension OfflineMapSyncParameters.PreplannedScheduledUpdatesOption {
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
    
    static func fromFlutter(_ flutterValue: Int) -> OfflineMapSyncParameters.PreplannedScheduledUpdatesOption {
        switch flutterValue {
        case 0:
            return .noUpdates
        case 1:
            return .downloadAllUpdates
        default:
            fatalError("Unexpected value: \(flutterValue)")
        }
    }
}

extension OfflineMapUpdatesInfo.Availability {
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
    
    static func fromFlutter(_ flutterValue: Int) -> OfflineMapUpdatesInfo.Availability {
        switch flutterValue {
        case -1:
            return .indeterminate
        case 0:
            return .available
        case 1:
            return .noneAvailable
        default:
            fatalError("Unexpected value: \(flutterValue)")
        }
    }
}
