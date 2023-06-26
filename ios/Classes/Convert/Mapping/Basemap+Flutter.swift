//
// Created by Valentin Grigorean on 26.06.2023.
//

import Foundation
import ArcGIS

extension Basemap {
    convenience init(data: Dictionary<String, Any>) {
        if let basemapStyle = data["basemapStyle"] as? Int {
            self.init(style: Basemap.Style.fromFlutter(basemapStyle))
            return
        }

        if let portalItem = data["portalItem"] as? Dictionary<String, Any> {
            self.init(item: PortalItem(data: portalItem))
            return
        }

        if let baseLayer = data["baseLayer"] as? Dictionary<String, Any> {
            let flutterLayer = FlutterLayer(data: baseLayer)
            self.init(baseLayer: flutterLayer.createNativeLayer())
            return
        }

        if let uri = data["uri"] as? String {
            self.init(url: URL(string: uri)!)
            return
        }

        let baseLayers = (data["baseLayers"] as [Dictionary<String, Any>] ?? []).map { (baseLayer) -> AGSLayer in
            let flutterLayer = FlutterLayer(data: baseLayer)
            return flutterLayer.createNativeLayer()
        }

        let referenceLayers = (data["referenceLayers"] as [Dictionary<String, Any>] ?? []).map { (baseLayer) -> AGSLayer in
            let flutterLayer = FlutterLayer(data: baseLayer)
            return flutterLayer.createNativeLayer()
        }

        self.init(baseLayers: baseLayers, referenceLayers: referenceLayers)
    }
}