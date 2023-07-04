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
            MapView(map: viewModel.map, viewpoint: viewModel.viewpoint, timeExtent: $viewModel.timeExtent, graphicsOverlays: viewModel.graphicsOverlays)
                    .onScaleChanged { newScale in
                        viewModel.currentScale = newScale
                    }
                    .onViewpointChanged(kind: .centerAndScale) { viewpoint in
                        viewModel.viewpoint = viewpoint
                        viewModel.viewpointCenterAndScale = viewpoint
                    }
                    .onViewpointChanged(kind: .boundingGeometry) { viewpoint in
                        viewModel.viewpoint = viewpoint
                        viewModel.viewpointBoundingGeometry = viewpoint
                    }
                    .attributionBarHidden(viewModel.isAttributionTextVisible)
                    .locationDisplay(viewModel.locationDisplay)
                    .selectionColor(viewModel.selectedColor)
                    .interactionModes(viewModel.interactionModes)
                    .edgesIgnoringSafeArea(viewModel.ignoresSafeAreaEdges ? .all : [])
                    .padding(viewModel.contentInsets)
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

    @Published var viewpoint: Viewpoint?

    @Published var viewpointCenterAndScale: Viewpoint?
    @Published var viewpointBoundingGeometry: Viewpoint?

    @Published var timeExtent: TimeExtent?

    @Published var interactionModes: MapViewInteractionModes = .all

    @Published var interactionsEnabled: Bool = true

    @Published var ignoresSafeAreaEdges: Bool = false

    @Published var contentInsets: EdgeInsets = EdgeInsets()

    @Published var isAttributionTextVisible: Bool = true


    let locationDisplay = LocationDisplay()

    var geoProxyView: MapViewProxy?

    var minScale: Double? {
        didSet {
            map.minScale = minScale
        }
    }

    var maxScale: Double? {
        didSet {
            map.maxScale = maxScale
        }
    }

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

    func updateMapOptions(with options: [String: Any]) {

        if let interactionOptions = options["interactionOptions"] as? Dictionary<String, Any> {
            updateInteractionOptions(with: interactionOptions)
        }

        if let myLocationEnabled = options["myLocationEnabled"] as? Bool {
            locationDisplay.showsLocation = myLocationEnabled

        }

        if let isAttributionTextVisible = options["isAttributionTextVisible"] as? Bool {
            self.isAttributionTextVisible = isAttributionTextVisible
        }

        if let contentInsets = options["contentInsets"] as? [Double] {
            // order is left,top,right,bottom
            self.contentInsets = EdgeInsets(top: CGFloat(contentInsets[1]), leading: CGFloat(contentInsets[0]),
                    bottom: CGFloat(contentInsets[3]), trailing: CGFloat(contentInsets[2]))
        }

        if let minScale = options["minScale"] as? Double {
            self.minScale = minScale
        }

        if let maxScale = options["maxScale"] as? Double {
            self.maxScale = maxScale
        }
    }

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