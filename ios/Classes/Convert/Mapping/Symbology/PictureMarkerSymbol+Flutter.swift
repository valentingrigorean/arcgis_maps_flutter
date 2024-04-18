//
// Created by Valentin Grigorean on 18.04.2024.
//

import Foundation
import ArcGIS

extension PictureMarkerSymbol {
    func interpretPictureMarkerSymbol(data: Dictionary<String, Any>) {
        self.interpretMarkerSymbol(data: data)
        if let height = data["height"] as? Double {
            self.height = CGFloat(height)
        }

        if let width = data["width"] as? Double {
            self.width = CGFloat(width)
        }
    }
}