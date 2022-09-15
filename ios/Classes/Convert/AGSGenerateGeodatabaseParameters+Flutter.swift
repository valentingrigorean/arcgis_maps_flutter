//
// Created by Valentin Grigorean on 29.07.2022.
//

import Foundation
import ArcGIS

extension AGSGenerateGeodatabaseParameters {
    convenience init(data: Dictionary<String, Any>) {
        self.init()
        attachmentSyncDirection = AGSAttachmentSyncDirection(rawValue: data["attachmentSyncDirection"] as! Int)!
        if let geometry = data["extent"] as? Dictionary<String, Any> {
            extent = AGSGeometry.fromFlutter(data: geometry)
        }
        layerOptions = (data["layerOptions"] as! [Dictionary<String, Any>]).map({ AGSGenerateLayerOption(data: $0) })
        if let outSpatialReference = data["outSpatialReference"] as? Dictionary<String, Any> {
            self.outSpatialReference = AGSSpatialReference(data: outSpatialReference)
        }
        returnAttachments = data["returnAttachments"] as! Bool
        shouldSyncContingentValues = data["shouldSyncContingentValues"] as! Bool
        syncModel = AGSSyncModel(rawValue: data["syncModel"] as! Int)!
        utilityNetworkSyncMode = AGSUtilityNetworkSyncMode(rawValue: data["utilityNetworkSyncMode"] as! Int)!
    }

    func toJSONFlutter() -> Any {
        var json = [String: Any]()
        json["attachmentSyncDirection"] = attachmentSyncDirection.rawValue
        if let extent = extent {
            json["extent"] = extent.toJSONFlutter()
        }
        json["layerOptions"] = layerOptions.map {
            $0.toJSONFlutter()
        }
        if let outSpatialReference = outSpatialReference {
            json["outSpatialReference"] = outSpatialReference.toJSONFlutter()
        }
        json["returnAttachments"] = returnAttachments
        json["shouldSyncContingentValues"] = shouldSyncContingentValues
        json["syncModel"] = syncModel.rawValue
        json["utilityNetworkSyncMode"] = utilityNetworkSyncMode.rawValue
        return json
    }
}