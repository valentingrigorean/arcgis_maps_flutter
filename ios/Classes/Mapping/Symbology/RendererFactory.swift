//
// Created by Valentin Grigorean on 18.04.2024.
//

import Foundation
import ArcGIS

class RendererFactory {
    static func createRenderer(data: Any?) -> Renderer? {
        guard let data = data as? Dictionary<String, Any> else {
            return nil
        }

        guard let type = data["type"] as? String else {
            return nil
        }
        switch type {
        case "unique-value":
            return UniqueValueRenderer(data: data)
        default:
            return nil
        }
    }
}
