//
//  MapViewModel.swift
//  arcgis_maps_flutter
//
//  Created by Valentin Grigorean on 02.07.2023.
//

import Foundation
import ArcGIS
import SwiftUI

struct MapContentView: View {
    @ObservedObject var viewModel: MapViewModel

    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        MapViewReader { proxy in
            MapView(map: viewModel.map, viewpoint: viewModel.viewPoint, timeExtent: $viewModel.timeExtent, graphicsOverlays: viewModel.graphicsOverlays)
                    .locationDisplay(viewModel.locationDisplay)
                    .selectionColor(viewModel.selectedColor)
                    .interactionModes(viewModel.interactionModes)
                    .onScaleChanged { newScale in
                        viewModel.currentScale = newScale
                    }
                    .onViewpointChanged(kind: .centerAndScale) { viewpoint in
                        viewModel.viewPoint = viewpoint
                    }
                    .onViewpointChanged(kind: .boundingGeometry) { viewpoint in
                        viewModel.viewPoint = viewpoint
                    }
                    .disabled(!viewModel.interactionsEnabled)
                    .onAppear {
                        viewModel.geoProxyView = proxy
                    }
        }
    }
}

class MapViewModel: ObservableObject {
    @Published var map = Map()
    @Published var graphicsOverlays: [GraphicsOverlay] = []

    @Published var currentScale: Double?

    @Published var rotation: Double?

    @Published var selectedColor: Color = .cyan

    @Published var viewPoint: Viewpoint?

    @Published var timeExtent: TimeExtent?

    @Published var interactionModes: MapViewInteractionModes = .all

    @Published var interactionsEnabled: Bool = true

    let locationDisplay = LocationDisplay()

    var geoProxyView: GeoViewProxy?

    func addGraphicOverlay(_ graphicsOverlay: GraphicsOverlay) {
        graphicsOverlays.append(graphicsOverlay)
    }

    func removeGraphicOverlay(_ graphicsOverlay: GraphicsOverlay) {
        graphicsOverlays.removeAll {
            $0 === graphicsOverlay
        }
    }
}


extension MapViewModel {
    func updateInteractionOptions(with options: [String: Any]) {
        var newInteractionModes: MapViewInteractionModes = []

        if let isEnabled = options["isEnabled"] as? Bool {
            interactionsEnabled = isEnabled
        }

        if let isRotateEnabled = options["isRotateEnabled"] as? Bool, isRotateEnabled {
            newInteractionModes.insert(.rotate)
        }

        if let isPanEnabled = options["isPanEnabled"] as? Bool, isPanEnabled {
            newInteractionModes.insert(.pan)
        }

        if let isZoomEnabled = options["isZoomEnabled"] as? Bool, isZoomEnabled {
            newInteractionModes.insert(.zoom)
        }

        interactionModes = newInteractionModes
    }
}



