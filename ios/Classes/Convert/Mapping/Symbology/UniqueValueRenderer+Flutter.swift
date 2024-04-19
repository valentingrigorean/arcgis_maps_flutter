//
// Created by Valentin Grigorean on 18.04.2024.
//

import Foundation
import ArcGIS

extension RotationType{
    init(_ flutterValue:String){
        switch flutterValue {
        case "geographic":
            self = .geographic
            break
        case "arithmetic":
            self = .arithmetic
            break
        default:
            fatalError("Invalid RotationType value \(flutterValue)")
        }
    }
}


extension UniqueValueRenderer {
    convenience init(data: [String: Any]) {
        let fieldsNames = data["fieldsNames"] as! [String]
        let uniqueValues = (data["uniqueValues"] as! [[String: Any]]).map {
            UniqueValue(data: $0)
        }
        let defaultLabel = data["defaultLabel"] as! String
        let defaultSymbol = SymbolFactory.createSymbol(data: data["defaultSymbol"])
        self.init(fieldNames:fieldsNames, uniqueValues: uniqueValues, defaultLabel: defaultLabel, defaultSymbol: defaultSymbol)
        if let rotationExpression = data["rotationExpression"] as? String{
            self.rotationExpression = rotationExpression
        }
        if let rotationType = data["rotationType"] as? String{
            self.rotationType = RotationType(rotationType)
        }
    }
}
