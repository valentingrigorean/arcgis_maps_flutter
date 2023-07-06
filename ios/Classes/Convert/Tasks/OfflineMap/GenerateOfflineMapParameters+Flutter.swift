//
// Created by Valentin Grigorean on 22.06.2022.
//

import Foundation
import ArcGIS

extension GenerateOfflineMapParameters {
    convenience init(data: [String: Any]) {
        let areaOfInterest = Geometry.fromFlutter(data: data["areaOfInterest"] as! [String: Any])!
        let minScale = data["minScale"] as? Double
        let maxScale = data["maxScale"] as? Double
        self.init(areaOfInterest: areaOfInterest, minScale: minScale, maxScale: maxScale)
        onlineOnlyServicesOption = GenerateOfflineMapParameters.OnlineOnlyServicesOption(data["onlineOnlyServicesOption"] as! Int)
        if let itemInfo = data["itemInfo"] as? [String: Any] {
            self.itemInfo = OfflineMapItemInfo(data: itemInfo)
        }
        attachmentSyncDirection = AttachmentSyncDirection(data["attachmentSyncDirection"] as! Int)
        continuesOnErrors = data["continueOnErrors"] as! Bool
        includesBasemap = data["includeBasemap"] as! Bool
        definitionExpressionFilterIsEnabled = data["isDefinitionExpressionFilterEnabled"] as! Bool
        returnLayerAttachmentOption = ReturnLayerAttachmentOption(data["returnLayerAttachmentOption"] as! Int)
        returnsSchemaOnlyForEditableLayers = data["returnSchemaOnlyForEditableLayers"] as! Bool
        updateMode = GenerateOfflineMapParameters.UpdateMode(data["updateMode"] as! Int)
        destinationTableRowFilter = GenerateOfflineMapParameters.DestinationTableRowFilter(data["destinationTableRowFilter"] as! Int)
        esriVectorTilesDownloadOption = EsriVectorTilesDownloadOption(data["esriVectorTilesDownloadOption"] as! Int)
        if let referenceBasemapDirectory = data["referenceBasemapDirectory"] as? String {
            referenceBasemapDirectoryURL = URL(string: referenceBasemapDirectory)
        }
        referenceBasemapFilename = data["referenceBasemapFilename"] as! String
    }

    func toJSONFlutter() -> Any {
        var data = [
            "areaOfInterest": areaOfInterest?.toJSONFlutter(),
            "minScale": minScale,
            "maxScale": maxScale,
            "onlineOnlyServicesOption": onlineOnlyServicesOption.toFlutterValue(),
            "attachmentSyncDirection": attachmentSyncDirection.toFlutterValue(),
            "continueOnErrors": continuesOnErrors,
            "includeBasemap": includesBasemap,
            "isDefinitionExpressionFilterEnabled": definitionExpressionFilterIsEnabled,
            "returnLayerAttachmentOption": returnLayerAttachmentOption.toFlutterValue(),
            "returnSchemaOnlyForEditableLayers": returnsSchemaOnlyForEditableLayers,
            "updateMode": updateMode.toFlutterValue(),
            "destinationTableRowFilter": destinationTableRowFilter.toFlutterValue(),
            "esriVectorTilesDownloadOption": esriVectorTilesDownloadOption.toFlutterValue(),
            "referenceBasemapFilename": referenceBasemapFilename,
        ] as [String: Any]

        if let itemInfo = itemInfo {
            data["itemInfo"] = itemInfo.toJSONFlutter()
        }

        if let referenceBasemapDirectory = referenceBasemapDirectoryURL {
            data["referenceBasemapDirectory"] = referenceBasemapDirectory.absoluteString
        }

        return data
    }
}
