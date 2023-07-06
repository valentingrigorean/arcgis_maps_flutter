//
// Created by Valentin Grigorean on 29.07.2022.
//

import Foundation
import ArcGIS

extension GenerateGeodatabaseParameters {
    convenience init(data: [String: Any]) {
        self.init()
        attachmentSyncDirection = AttachmentSyncDirection(data["attachmentSyncDirection"] as! Int)
        if let geometry = data["extent"] as? [String: Any] {
            extent = Geometry.fromFlutter(data: geometry)
        }
        let newLayers = (data["layerOptions"] as! [[String: Any]]).map({ GenerateLayerOption(data: $0) })
        for layer in newLayers {
            addLayerOption(layer)
        }
        
        if let outSpatialReference = data["outSpatialReference"] as? [String: Any] {
            self.outSpatialReference = SpatialReference(data: outSpatialReference)
        }
        returnsAttachments = data["returnAttachments"] as! Bool
        syncsContingentValues = data["shouldSyncContingentValues"] as! Bool
        syncModel = Geodatabase.SyncModel(data["syncModel"] as! Int)
        utilityNetworkSyncMode = UtilityNetworkSyncMode(data["utilityNetworkSyncMode"] as! Int)
    }

    func toJSONFlutter() -> Any {
        var json = [String: Any]()
        json["attachmentSyncDirection"] = attachmentSyncDirection.toFlutterValue()
        if let extent = extent {
            json["extent"] = extent.toJSONFlutter()
        }
        json["layerOptions"] = layerOptions.map {
            $0.toJSONFlutter()
        }
        if let outSpatialReference = outSpatialReference {
            json["outSpatialReference"] = outSpatialReference.toJSONFlutter()
        }
        json["returnAttachments"] = returnsAttachments
        json["shouldSyncContingentValues"] = syncsContingentValues
        json["syncModel"] = syncModel.toFlutterValue()
        json["utilityNetworkSyncMode"] = utilityNetworkSyncMode.toFlutterValue()
        return json
    }
}
