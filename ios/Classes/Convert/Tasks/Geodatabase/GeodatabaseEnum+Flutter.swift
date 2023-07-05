//
//  GeodatabaseEnum+Flutter.swift
//  arcgis_maps_flutter
//
//  Created by Valentin Grigorean on 02.05.2023.
//

import Foundation
import ArcGIS

extension AttachmentSyncDirection {

    init(_ flutterValue: Int) {
        switch flutterValue {
        case 1:
            self = AttachmentSyncDirection.upload
        case 2:
            self = AttachmentSyncDirection.bidirectional
        default:
            self = AttachmentSyncDirection.noSync
        }
    }

    func toFlutterValue() -> Int {
        switch self {
        case .upload:
            return 1
        case .bidirectional:
            return 2
        case .noSync:
            return 0
        default:
            return 0
        }
    }
}


extension GenerateLayerOption.QueryOption {

    init(_ flutterValue: Int) {
        switch flutterValue {
        case 0:
            self = GenerateLayerOption.QueryOption.all
        case 1:
            self = GenerateLayerOption.QueryOption.noneOrRelatedOnly
        case 2:
            self = GenerateLayerOption.QueryOption.useFilter
        default:
            self = GenerateLayerOption.QueryOption.all
        }
    }

    func toFlutterValue() -> Int {
        switch self {
        case .all:
            return 0
        case .noneOrRelatedOnly:
            return 1
        case .useFilter:
            return 2
        default:
            return 0
        }
    }
}


extension Geodatabase.SyncModel {
    init(_ flutterValue: Int) {
        switch flutterValue {
        case 1:
            self = Geodatabase.SyncModel.geodatabase
        case 2:
            self = Geodatabase.SyncModel.layer
        default:
            self = Geodatabase.SyncModel.disabled
        }
    }

    func toFlutterValue() -> Int {
        switch self {
        case .disabled:
            return 0
        case .geodatabase:
            return 1
        case .layer:
            return 2
        default:
            return 0
        }
    }
}


extension UtilityNetworkSyncMode {

    init(_ flutterValue: Int) {
        switch flutterValue {
        case 1:
            self = UtilityNetworkSyncMode.syncSystemTables
        case 2:
            self = UtilityNetworkSyncMode.syncSystemAndTopologyTables
        default:
            self = UtilityNetworkSyncMode.noSync
        }
    }


    func toFlutterValue() -> Int {
        switch self {
        case .noSync:
            return 0
        case .syncSystemTables:
            return 1
        case .syncSystemAndTopologyTables:
            return 2
        default:
            return 0
        }
    }

}


extension SyncDirection {
    init(_ flutterValue: Int) {
        switch flutterValue {
        case 1:
            self = SyncDirection.download
        case 2:
            self = SyncDirection.download
        case 3:
            self = SyncDirection.bidirectional
        default:
            self = SyncDirection.noSync
        }
    }

    func toFlutterValue() -> Int {
        switch self {
        case .noSync:
            return 0
        case .download:
            return 1
        case .upload:
            return 2
        case .bidirectional:
            return 3
        default:
            return 0
        }
    }
}
