//
// Created by Valentin Grigorean on 25.03.2021.
//

import Foundation
import ArcGIS

struct FlutterLayer: Hashable {


    init(data: Dictionary<String, Any>) {
        layerId = data["layerId"] as! String
        layerType = data["layerType"] as! String
        url = URL(string: data["url"] as! String)

        isVisible = data["isVisible"] as! Bool
        opacity = Float(data["opacity"] as! Double)

        if let credential = data["credential"] as? Dictionary<String, Any> {
            self.credential = AGSCredential(data: credential)
        } else {
            credential = nil
        }

        layersName = data["layersName"] as? [String]
    }

    let layerId: String
    let layerType: String
    let opacity: Float
    let isVisible: Bool
    let url: URL?
    let layersName: [String]?

    let credential: AGSCredential?
}