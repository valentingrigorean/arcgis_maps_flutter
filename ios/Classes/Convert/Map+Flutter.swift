//
// Created by Valentin Grigorean on 24.03.2021.
//

import Foundation
import ArcGIS

extension Map {
    convenience init(data: Dictionary<String, Any>) {
        if let basemap = data["basemap"] as? String {
            self.init(basemap: Basemap(data: basemap))
            return
        }

        if let basemapStyle = data["basemapStyle"] as? Int? {
            self.init(basemap: Basemap(style: Basemap.Style(flutterValue: basemapStyle)))
            return
        }

        if let item = data["item"] as? Dictionary<String, Any> {
            self.init(item: PortalItem(data: item))
            return
        }

        if let spatialReference = data["spatialReference"] as? Dictionary<String, Any> {
            self.init(spatialReference: SpatialReference(data: spatialReference))
            return
        }

        if let uri = data["uri"] as? String {
            self.init(url: URL(string: uri)!)
            return
        }

        self.init()
    }
}
