//
// Created by Valentin Grigorean on 11.07.2021.
//

import Foundation
import ArcGIS
import ArcGISToolkit

class ScaleBarController {
    private let mapView: AGSMapView
    private var scaleBar : Scalebar?

    init(mapView: AGSMapView) {
        self.mapView = mapView
        self.scaleBar = nil
    }
}