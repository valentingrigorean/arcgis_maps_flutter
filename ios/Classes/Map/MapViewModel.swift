//
//  MapViewModel.swift
//  arcgis_maps_flutter
//
//  Created by Valentin Grigorean on 02.07.2023.
//

import Foundation
import ArcGIS
import SwiftUI
import Combine


struct MapContentView: View {

    @State private var lastLongPressEvent: (CGPoint, ArcGIS.Point, MapViewProxy)?

    @ObservedObject var viewModel: MapViewModel

    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        if viewModel.map == nil {
            EmptyView()
        } else {
            let longPressGesture = LongPressGesture(minimumDuration: 0.5, maximumDistance: .infinity)
                    .onEnded { _ in
                        if let lastLongPressEvent = lastLongPressEvent {
                            viewModel.handleLongTapEnded(screenPoint: lastLongPressEvent.0, mapPoint: lastLongPressEvent.1, mapViewProxy: lastLongPressEvent.2)
                        }
                        lastLongPressEvent = nil
                    }

            MapViewReader { proxy in
                MapView(map: viewModel.map!, viewpoint: viewModel.viewpoint, timeExtent: $viewModel.timeExtent, graphicsOverlays: viewModel.graphicsOverlays)
                        .onScaleChanged { newScale in
                            viewModel.currentScale = newScale
                        }
                        .onRotationChanged { newRotation in
                            viewModel.rotation = newRotation
                        }
                        .onViewpointChanged(kind: .centerAndScale) { viewpoint in
                            viewModel.viewpointCenterAndScale = viewpoint
                        }
                        .onViewpointChanged(kind: .boundingGeometry) { viewpoint in
                            viewModel.viewpointBoundingGeometry = viewpoint
                        }
                        .onUnitsPerPointChanged {
                            viewModel.unitsPerPoint = $0
                        }
                        .onSpatialReferenceChanged {
                            viewModel.spatialReference = $0
                        }
                        .onSingleTapGesture { screenPoint, mapPoint in
                            viewModel.handleSingleTap(screenPoint: screenPoint, mapPoint: mapPoint, mapViewProxy: proxy)
                        }
                        .onLongPressGesture { screenPoint, mapPoint in
                            lastLongPressEvent = (screenPoint, mapPoint, proxy)
                            viewModel.handleLongTap(screenPoint: screenPoint, mapPoint: mapPoint, mapViewProxy: proxy)
                        }
                        .attributionBarHidden(viewModel.isAttributionTextVisible)
                        .locationDisplay(viewModel.locationDisplay)
                        .selectionColor(viewModel.selectedColor)
                        .interactionModes(viewModel.interactionModes)
                        .contentInsets(viewModel.contentInsets)
                        .gesture(longPressGesture)
                        .edgesIgnoringSafeArea(viewModel.ignoresSafeAreaEdges ? .all : [])
                        .disabled(!viewModel.interactionsEnabled)
                        .onAppear {
                            viewModel.mapViewProxy = proxy
                        }
            }.overlay(alignment: viewModel.scalebarConfig.alignment ?? .topLeading) {
                        if viewModel.haveScaleBar {
                            Scalebar(
                                    maxWidth: viewModel.scalebarConfig.maxWidth,
                                    settings: viewModel.scalebarConfig.settings,
                                    spatialReference: $viewModel.spatialReference,
                                    style: viewModel.scalebarConfig.style,
                                    units: viewModel.scalebarConfig.units,
                                    unitsPerPoint: $viewModel.unitsPerPoint,
                                    viewpoint: $viewModel.viewpointCenterAndScale
                            ).ignoresSafeArea()
                                    .offset(viewModel.scalebarConfig.offset ?? .zero)
                        }else{
                            EmptyView()
                        }
                    }
        }
    }
}

struct FlutterScalebarConfig {
    var settings: ScalebarSettings
    var units: ScalebarUnits
    var style: ScalebarStyle
    var alignment: Alignment?
    var offset: CGSize?
    var maxWidth: Double = 175.0
}


class MapViewModel: ObservableObject {
    @Published var map: Map? {
        didSet {
            map?.minScale = minScale
            map?.maxScale = maxScale
        }
    }
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

    @Published var haveScaleBar: Bool = true

    @Published var scalebarConfig: FlutterScalebarConfig = FlutterScalebarConfig(settings: ScalebarSettings(), units: NSLocale.current.usesMetricSystem ? .metric : .imperial, style: .alternatingBar)

    @Published var spatialReference: SpatialReference?

    @Published var unitsPerPoint: Double?

    let singleTapEvent = PassthroughSubject<(CGPoint, ArcGIS.Point, MapViewProxy), Never>()
    let longTapEvent = PassthroughSubject<(CGPoint, ArcGIS.Point, MapViewProxy), Never>()
    let longTapEndedEvent = PassthroughSubject<(CGPoint, ArcGIS.Point, MapViewProxy), Never>()

    let locationDisplay = LocationDisplay()

    var mapViewProxy: MapViewProxy?

    var minScale: Double? {
        didSet {
            map?.minScale = minScale
        }
    }

    var maxScale: Double? {
        didSet {
            map?.maxScale = maxScale
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

    func handleSingleTap(screenPoint: CGPoint, mapPoint: ArcGIS.Point, mapViewProxy: MapViewProxy) {
        singleTapEvent.send((screenPoint, mapPoint, mapViewProxy))
    }

    func handleLongTap(screenPoint: CGPoint, mapPoint: ArcGIS.Point, mapViewProxy: MapViewProxy) {
        longTapEvent.send((screenPoint, mapPoint, mapViewProxy))
    }

    func handleLongTapEnded(screenPoint: CGPoint, mapPoint: ArcGIS.Point, mapViewProxy: MapViewProxy) {
        longTapEndedEvent.send((screenPoint, mapPoint, mapViewProxy))
    }
}


extension MapViewModel {

    func updateMapOptions(with options: [String: Any]) {

        if let interactionOptions = options["interactionOptions"] as? [String: Any] {
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

        if let insetsContentInsetFromSafeArea = options["insetsContentInsetFromSafeArea"] as? Bool {
            ignoresSafeAreaEdges = insetsContentInsetFromSafeArea
        }

        if let minScale = options["minScale"] as? Double {
            self.minScale = minScale
        }

        if let maxScale = options["maxScale"] as? Double {
            self.maxScale = maxScale
        }

        if let haveScaleBar = options["haveScalebar"] as? Bool {
            self.haveScaleBar = haveScaleBar
        }

        if let scalebarConfiguration = options["scalebarConfiguration"] as? [String: Any] {
            scalebarConfig = createScalebarConfig(data: scalebarConfiguration)
        }
    }

    private func updateInteractionOptions(with options: [String: Any]) {
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

    private func createScalebarConfig(data: [String: Any]) -> FlutterScalebarConfig {
        let units = ScalebarUnits(data["units"] as! Int)
        let style = ScalebarStyle(data["style"] as! Int)
        let settings = ScalebarSettings(data: data)
        let maxWidth = data["maxWidth"] as? Double ?? 175.0
        let alignment = data["alignment"] as? Int
        let offset = data["offset"] as? [Double]

        return FlutterScalebarConfig(
                settings: settings,
                units: units,
                style: style,
                alignment: alignment == nil ? nil : getSwiftUIAlignment(value: alignment!),
                offset: offset == nil ? nil : CGSize(width: offset![0], height: offset![1]),
                maxWidth: maxWidth
        )
    }


    private func getSwiftUIAlignment(value: Int) -> Alignment {
        switch value {
        case 0:
            return .bottomLeading
        case 1:
            return .bottomTrailing
        case 2:
            return .bottom // For CENTER alignment
        default:
            fatalError("Invalid alignment value")
        }
    }

}

extension ScalebarSettings {
    init(data: [String: Any]) {
        autoHide = data["autoHide"] as? Bool ?? true
        autoHideDelay = (data["autoHideDelay"] as? Double ?? 2000.0) / 1000.0
        barCornerRadius = data["barCornerRadius"] as? Double ?? 2.5
        fillColor1 = Color(data: data["fillColor"] as! UInt)
        fillColor2 = Color(data: data["alternateFillColor"] as! UInt)
        lineColor = Color(data: data["lineColor"] as! UInt)
        shadowColor = Color(data: data["shadowColor"] as! UInt)
        shadowRadius = data["shadowRadius"] as? Double ?? 1.0
        textColor = Color(data: data["textColor"] as! UInt)
        textShadowColor = Color(data: data["textShadowColor"] as! UInt)
    }
}
