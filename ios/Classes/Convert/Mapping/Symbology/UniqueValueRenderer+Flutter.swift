//
// Created by Valentin Grigorean on 18.04.2024.
//

import Foundation
import ArcGIS


extension UniqueValueRenderer {
    convenience init(data: [String: Any]) {
        let fieldsNames = data["fieldsNames"] as! [String]
        let uniqueValues = (data["uniqueValues"] as! [[String: Any]]).map {
            UniqueValue(data: $0)
        }
        let defaultLabel = data["defaultLabel"] as! String
        let defaultSymbol = SymbolFactory.createSymbol(data: data["defaultSymbol"])
        self.init(fieldNames:fieldsNames, uniqueValues: uniqueValues, defaultLabel: defaultLabel, defaultSymbol: defaultSymbol)
    }
}
