//
// Created by Valentin Grigorean on 09.11.2021.
//

import Foundation

extension Dictionary where Key == String, Value == Any {
    func toFlutterTypes() -> Dictionary<String, Any> {
        var flutterAttributes = [String: Any]()

        for attr in self {
            flutterAttributes[attr.key] = toFlutterFieldType(obj: attr.value)
        }
        return flutterAttributes
    }
}

extension NSMutableDictionary {
    func toFlutterTypes() -> Dictionary<String, Any> {
        var flutterAttributes = [String: Any]()

        for attr in self {
            flutterAttributes[attr.key as! String] = toFlutterFieldType(obj: attr.value)
        }
        return flutterAttributes
    }
}