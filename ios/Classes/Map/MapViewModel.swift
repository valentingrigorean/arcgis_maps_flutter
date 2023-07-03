//
//  MapViewModel.swift
//  arcgis_maps_flutter
//
//  Created by Valentin Grigorean on 02.07.2023.
//

import Foundation
import ArcGIS



class MapViewModel: ObservableObject {
    @Published var map = Map()
    @Published var graphicsOverlays: [GraphicsOverlay] = []

    let locationDisplay = LocationDisplay()

    var geoProxyView : GeoViewProxy?

    func addGraphicOverlay(_ graphicsOverlay: GraphicsOverlay) {
        graphicsOverlays.append(graphicsOverlay)
    }

    func removeGraphicOverlay(_ graphicsOverlay: GraphicsOverlay) {
        graphicsOverlays.removeAll {
            $0 === graphicsOverlay
        }
    }
}
