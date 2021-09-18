//
// Created by Valentin Grigorean on 11.09.2021.
//

import Foundation
import ArcGIS

class LayersChangedController {

    private let geoView: AGSGeoView
    private let channel: FlutterMethodChannel
    private let layersController: LayersController

    private var mapObservation: NSKeyValueObservation?

    private var mapOperationalLayersObservation: NSKeyValueObservation?

    private var mapBaseLayersObservation: NSKeyValueObservation?

    private var mapReferenceLayersObservation: NSKeyValueObservation?

    private var map: AGSMap?

    private var isObserving: Bool = false

    var trackLayersChange: Bool = false {
        didSet {
            if trackLayersChange {
                addObservers()
            } else {
                removeObservers()
            }
        }
    }

    init(geoView: AGSGeoView,
         channel: FlutterMethodChannel,
         layersController: LayersController) {
        self.geoView = geoView
        self.channel = channel
        self.layersController = layersController

        if let mapView = geoView as? AGSMapView {
            mapObservation = mapView.observe(\.map, options: [.new, .initial]) { [weak self] (_,
                                                                                              change) in
                self?.handleMapChange(change: change)
            }
        } else {
            mapObservation = nil
        }
    }

    deinit {
        mapObservation?.invalidate()
        removeObservers()
    }

    private func handleMapChange(change: NSKeyValueObservedChange<AGSMap?>) -> Void {
        map = change.newValue as? AGSMap
        if trackLayersChange {
            addObservers()
        }
    }

    private func handleLayerChanged(layerType: LayerType,
                                    change: NSKeyValueObservedChange<NSMutableArray>) {

        var changeType = 0

        switch change.kind {

        case .insertion:
            changeType = 0
            break
        case .removal:
            changeType = 1
            break
        @unknown default:
            changeType = 2
            break
        }

        channel.invokeMethod("map#onLayersChanged", arguments: [
            "layerType": layerType.rawValue,
            "layerChangeType": changeType,
        ])
    }


    private func addObservers() {
        if isObserving {
            removeObservers()
        }

        AGSPortalItem.

        mapOperationalLayersObservation = map?.observe(\.operationalLayers, options: [.new]) { [weak self] (_,
                                                                                                            change) in
            self?.handleLayerChanged(layerType: .operational, change: change)
        }

        mapBaseLayersObservation = map?.basemap.observe(\.baseLayers, options: [.new]) { [weak self] (_,
                                                                                                      change) in
            self?.handleLayerChanged(layerType: .base, change: change)
        }

        mapBaseLayersObservation = map?.basemap.observe(\.referenceLayers, options: [.new]) { [weak self] (_,
                                                                                                           change) in
            self?.handleLayerChanged(layerType: .reference, change: change)
        }

        isObserving = true
    }

    private func removeObservers() {
        if isObserving {
            mapOperationalLayersObservation?.invalidate()
            mapOperationalLayersObservation = nil
            mapBaseLayersObservation?.invalidate()
            mapBaseLayersObservation = nil
            mapBaseLayersObservation?.invalidate()
            mapBaseLayersObservation = nil
            isObserving = false
        }
    }
}

fileprivate extension AGSGeoView {
    var operationalLayers: [AGSLayer]? {
        if let mapView = self as? AGSMapView {
            if let layers = mapView.map?.operationalLayers as AnyObject as? [AGSLayer] {
                return layers
            }
        } else if let sceneView = self as? AGSSceneView {
            if let layers = sceneView.scene?.operationalLayers as AnyObject as? [AGSLayer] {
                return layers
            }
        }
        return nil
    }

    var baseLayers: [AGSLayer]? {
        if let mapView = self as? AGSMapView {
            if let layers = mapView.map?.basemap.baseLayers as AnyObject as? [AGSLayer] {
                return layers
            }
        } else if let sceneView = self as? AGSSceneView {
            if let layers = sceneView.scene?.basemap?.baseLayers as AnyObject as? [AGSLayer] {
                return layers
            }
        }
        return nil
    }

    var referenceLayers: [AGSLayer]? {
        if let mapView = self as? AGSMapView {
            if let layers = mapView.map?.basemap.referenceLayers as AnyObject as? [AGSLayer] {
                return layers
            }
        } else if let sceneView = self as? AGSSceneView {
            if let layers = sceneView.scene?.basemap?.referenceLayers as AnyObject as? [AGSLayer] {
                return layers
            }
        }
        return nil
    }


}
