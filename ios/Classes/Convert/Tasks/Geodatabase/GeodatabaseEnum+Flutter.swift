//
//  GeodatabaseEnum+Flutter.swift
//  arcgis_maps_flutter
//
//  Created by Valentin Grigorean on 02.05.2023.
//

import Foundation
import ArcGIS

extension AttachmentSyncDirection{
    
    static func fromFlutter(flutterValue:Int)  -> AttachmentSyncDirection{
        switch flutterValue {
        case 1:
            return AttachmentSyncDirection.upload
        case 2:
            return AttachmentSyncDirection.bidirectional
        default:
            return AttachmentSyncDirection.noSync
        }
    }
    
    func toFlutterValue() -> Int{
        switch self {
        case .upload:
            return 1
        case .bidirectional:
            return 2
        case .noSync:
            return 0
        @unknown default:
            return 0
        }
    }
}


extension GenerateLayerOption.QueryOption{
    
    static func fromFlutter(flutterValue:Int) -> GenerateLayerOption.QueryOption{
        switch flutterValue{
        case 0:
            return GenerateLayerOption.QueryOption.all
        case 1:
            return GenerateLayerOption.QueryOption.noneOrRelatedOnly
        case 2:
            return GenerateLayerOption.QueryOption.useFilter
        default:
            return GenerateLayerOption.QueryOption.all
        }
    }
    
    func toFlutterValue() -> Int{
        switch self {
        case .all:
            return 0
        case .noneOrRelatedOnly:
            return 1
        case .useFilter:
            return 2
        @unknown default:
            return 0
        }
    }
}


extension Geodatabase.SyncModel{
    static func fromFlutter(flutterValue:Int) -> Geodatabase.SyncModel{
        switch flutterValue{
        case 1:
            return Geodatabase.SyncModel.geodatabase
        case 2:
            return Geodatabase.SyncModel.layer
        default:
            return Geodatabase.SyncModel.disabled
        }
    }
    
    func toFlutterValue() -> Int{
        switch self{
        case .disabled:
            return 0
        case .geodatabase:
            return 1
        case .layer:
            return 2
        @unknown default:
            return 0
        }
    }
}


extension UtilityNetworkSyncMode{
    
    static func fromFlutter(flutterValue:Int)  -> UtilityNetworkSyncMode{
        switch flutterValue {
        case 1:
            return UtilityNetworkSyncMode.syncSystemTables
        case 2:
            return UtilityNetworkSyncMode.syncSystemAndTopologyTables
        default:
            return UtilityNetworkSyncMode.noSync
        }
    }
    
    
    func toFlutterValue() -> Int{
        switch self{
        case .noSync:
            return 0
        case .syncSystemTables:
            return 1
        case .syncSystemAndTopologyTables:
            return 2
        @unknown default:
            return 0
        }
    }

}


extension SyncDirection{
    static func fromFlutter(flutterValue:Int) -> SyncDirection{
        switch flutterValue{
        case 1:
            return SyncDirection.download
        case 2:
            return SyncDirection.download
        case 3:
            return SyncDirection.bidirectional
        default:
            return SyncDirection.noSync
        }
    }
    
    func toFlutterValue() -> Int{
        switch self{
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
