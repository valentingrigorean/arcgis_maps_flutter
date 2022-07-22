//
// Created by Valentin Grigorean on 22.06.2022.
//

import Foundation
import ArcGIS

extension AGSGenerateOfflineMapParameters{
    convenience init(data: [String: Any]) {
        let areaOfInterest = AGSGeometry.fromFlutter(data: data["areaOfInterest"] as! [String: Any])!
        let minScale = data["minScale"] as! Double
        let maxScale = data["maxScale"] as! Double
        self.init(areaOfInterest: areaOfInterest, minScale: minScale, maxScale: maxScale)
        onlineOnlyServicesOption = AGSOnlineOnlyServicesOption(rawValue: data["onlineOnlyServicesOption"] as! Int)!
        if let itemInfo = data["itemInfo"] as? [String: Any] {
            self.itemInfo = AGSOfflineMapItemInfo(data: itemInfo)
        }
        attachmentSyncDirection = AGSAttachmentSyncDirection(rawValue: data["attachmentSyncDirection"] as! Int)!
        continueOnErrors = data["continueOnErrors"] as! Bool
        includeBasemap = data["includeBasemap"] as! Bool
        isDefinitionExpressionFilterEnabled = data["isDefinitionExpressionFilterEnabled"] as! Bool
        returnLayerAttachmentOption = AGSReturnLayerAttachmentOption(rawValue: data["returnLayerAttachmentOption"] as! Int)!
        returnSchemaOnlyForEditableLayers = data["returnSchemaOnlyForEditableLayers"] as! Bool
        updateMode = AGSGenerateOfflineMapUpdateMode(rawValue: data["updateMode"] as! Int)!
        destinationTableRowFilter = AGSDestinationTableRowFilter(rawValue: data["destinationTableRowFilter"] as! Int)!
        esriVectorTilesDownloadOption = AGSEsriVectorTilesDownloadOption(rawValue: data["esriVectorTilesDownloadOption"] as! Int)!
        if let referenceBasemapDirectory  = data["referenceBasemapDirectory"] as? String{
            self.referenceBasemapDirectory = URL(string: referenceBasemapDirectory)
        }
        referenceBasemapFilename = data["referenceBasemapFilename"] as! String
    }

    func toJSONFlutter() -> Any {
        [
            "areaOfInterest": areaOfInterest.toJSONFlutter(),
            "minScale": minScale,
            "maxScale": maxScale,
            "onlineOnlyServicesOption": onlineOnlyServicesOption.rawValue,
            "itemInfo": itemInfo?.toJSONFlutter(),
            "attachmentSyncDirection": attachmentSyncDirection.rawValue,
            "continueOnErrors": continueOnErrors,
            "includeBasemap": includeBasemap,
            "isDefinitionExpressionFilterEnabled": isDefinitionExpressionFilterEnabled,
            "returnLayerAttachmentOption": returnLayerAttachmentOption.rawValue,
            "returnSchemaOnlyForEditableLayers": returnSchemaOnlyForEditableLayers,
            "updateMode": updateMode.rawValue,
            "destinationTableRowFilter": destinationTableRowFilter.rawValue,
            "esriVectorTilesDownloadOption": esriVectorTilesDownloadOption.rawValue,
            "referenceBasemapDirectory": referenceBasemapDirectory?.absoluteString,
            "referenceBasemapFilename": referenceBasemapFilename,
        ]
    }
}