//
// Created by Valentin Grigorean on 22.06.2022.
//

import Foundation
import ArcGIS

extension AGSGenerateOfflineMapParameters{
    func toJSONFlutter() -> Any {
        [
            "areaOfInterest": areaOfInterest.toJSONFlutter(),
            "minScale": minScale,
            "maxScale": maxScale,
            "onlineOnlyServicesOptions": onlineOnlyServicesOption.rawValue,
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