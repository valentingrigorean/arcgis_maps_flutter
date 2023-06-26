//
// Created by Valentin Grigorean on 22.06.2022.
//

import Foundation
import ArcGIS

extension GenerateOfflineMapParameters {
    convenience init(data: [String: Any]) {
        let areaOfInterest = Geometry.fromFlutter(data: data["areaOfInterest"] as! [String: Any])!
        let minScale = data["minScale"] as! Double
        let maxScale = data["maxScale"] as! Double
        self.init(areaOfInterest: areaOfInterest, minScale: minScale, maxScale: maxScale)
        onlineOnlyServicesOption = GenerateOfflineMapParameters.OnlineOnlyServicesOption(data["onlineOnlyServicesOption"] as! Int)
        if let itemInfo = data["itemInfo"] as? [String: Any] {
            self.itemInfo = OfflineMapItemInfo(data: itemInfo)
        }
        attachmentSyncDirection = AttachmentSyncDirection.fromFlutter(flutterValue: data["attachmentSyncDirection"] as! Int)
        continueOnErrors = data["continueOnErrors"] as! Bool
        includeBasemap = data["includeBasemap"] as! Bool
        isDefinitionExpressionFilterEnabled = data["isDefinitionExpressionFilterEnabled"] as! Bool
        returnLayerAttachmentOption = ReturnLayerAttachmentOption.fromFlutter(data["returnLayerAttachmentOption"] as! Int)
        returnSchemaOnlyForEditableLayers = data["returnSchemaOnlyForEditableLayers"] as! Bool
        updateMode = GenerateOfflineMapUpdateMode(rawValue: data["updateMode"] as! Int)
        destinationTableRowFilter = AGSDestinationTableRowFilter(rawValue: data["destinationTableRowFilter"] as! Int)!
        esriVectorTilesDownloadOption = AGSEsriVectorTilesDownloadOption(rawValue: data["esriVectorTilesDownloadOption"] as! Int)!
        if let referenceBasemapDirectory = data["referenceBasemapDirectory"] as? String {
            self.referenceBasemapDirectory = URL(string: referenceBasemapDirectory)
        }
        referenceBasemapFilename = data["referenceBasemapFilename"] as! String
    }

    func toJSONFlutter() -> Any {
        var data = [
            "areaOfInterest": areaOfInterest.toJSONFlutter(),
            "minScale": minScale,
            "maxScale": maxScale,
            "onlineOnlyServicesOption": onlineOnlyServicesOption.toFlutterValue(),
            "attachmentSyncDirection": attachmentSyncDirection.rawValue,
            "continueOnErrors": continueOnErrors,
            "includeBasemap": includeBasemap,
            "isDefinitionExpressionFilterEnabled": isDefinitionExpressionFilterEnabled,
            "returnLayerAttachmentOption": returnLayerAttachmentOption.rawValue,
            "returnSchemaOnlyForEditableLayers": returnSchemaOnlyForEditableLayers,
            "updateMode": updateMode.rawValue,
            "destinationTableRowFilter": destinationTableRowFilter.rawValue,
            "esriVectorTilesDownloadOption": esriVectorTilesDownloadOption.rawValue,
            "referenceBasemapFilename": referenceBasemapFilename,
        ]

        if let itemInfo = itemInfo {
            data["itemInfo"] = itemInfo.toJSONFlutter()
        }

        if let referenceBasemapDirectory = referenceBasemapDirectory {
            data["referenceBasemapDirectory"] = referenceBasemapDirectory.absoluteString
        }

        return data
    }
}
