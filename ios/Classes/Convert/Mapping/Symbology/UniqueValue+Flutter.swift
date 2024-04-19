//
// Created by Valentin Grigorean on 18.04.2024.
//

import Foundation
import ArcGIS



extension UniqueValue{
    convenience init(data:[String:Any]){
        let label = data["label"] as! String
        let description = data["description"] as! String
        let symbol =  SymbolFactory.createSymbol(data:data["symbol"])
        let values = data["values"] as! [Any]
        self.init(description: description, label: label, symbol: symbol, values: values)
    }
}
