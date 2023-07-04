//
//  File.swift
//  arcgis_maps_flutter
//
//  Created by Valentin Grigorean on 03.07.2023.
//

import Foundation

class GeoViewTouchDelegate{
    public func geoView(_ geoView: AGSGeoView,
                        didTapAtScreenPoint screenPoint: CGPoint,
                        mapPoint: Point) {
        graphicsHandle?.cancel()
        layerHandle?.cancel()

        lastScreenPoint = screenPoint

        if canConsumeGraphics() {
            graphicsHandle = mapView.identifyGraphicsOverlays(atScreenPoint: screenPoint, tolerance: 12, returnPopupsOnly: false, completion: identifyGraphicsOverlaysCallback)
        } else if trackIdentityLayers {
            layerHandle = mapView.identifyLayers(atScreenPoint: screenPoint, tolerance: 12, returnPopupsOnly: false, completion: identifyLayersCallback)
        } else {
            sendOnMapTap(screenPoint: screenPoint)
        }
    }


    public func geoView(_ geoView: AGSGeoView, didLongPressAtScreenPoint screenPoint: CGPoint, mapPoint: Point) {
        sendOnMapLongPress(screenPoint: screenPoint)
    }

    public func geoView(_ geoView: AGSGeoView, didEndLongPressAtScreenPoint screenPoint: CGPoint, mapPoint: Point) {
        sendOnMapLongPressEnd(screenPoint: screenPoint)
    }


    private func identifyGraphicsOverlaysCallback(results: [AGSIdentifyGraphicsOverlayResult]?,
                                                  error: Error?) {
        graphicsHandle = nil
        if error != nil {
            return
        }

        if onTapGraphicsCompleted(results: results, screenPoint: lastScreenPoint) {
            return
        }

        if trackIdentityLayers {
            layerHandle = mapView.identifyLayers(atScreenPoint: lastScreenPoint, tolerance: 10, returnPopupsOnly: false, completion: identifyLayersCallback)
        } else {
            sendOnMapTap(screenPoint: lastScreenPoint)
        }
    }

    private func identifyLayersCallback(results: [AGSIdentifyLayerResult]?,
                                        error: Error?) {
        layerHandle = nil
        if error != nil {
            return
        }
        guard let results = results else {
            sendOnMapTap(screenPoint: lastScreenPoint)
            return
        }
        if results.isEmpty {
            sendOnMapTap(screenPoint: lastScreenPoint)
            return
        }

        let position = mapView.screen(toLocation: lastScreenPoint)

        channel.invokeMethod("map#onIdentifyLayers", arguments: ["results": results.toJSONFlutter(), "screenPoint": lastScreenPoint.toJSONFlutter(), "position": position.toJSONFlutter()])
    }

    private func onTapGraphicsCompleted(results: [IdentifyGraphicsOverlayResult]?,
                                        screenPoint: CGPoint) -> Bool {
        if results != nil {
            for result in results! {
                for graphic in result.graphics {
                    for del in graphicsTouchDelegates {
                        if del.didHandleGraphic(graphic: graphic) {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }

    private func canConsumeGraphics() -> Bool {
        for del in graphicsTouchDelegates {
            if del.canConsumeTaps() {
                return true
            }
        }
        return false
    }

    private func sendOnMapTap(screenPoint: CGPoint) {
        if let json = mapView.screen(toLocation: screenPoint).toJSONFlutter() {
            channel.invokeMethod("map#onTap", arguments: ["screenPoint": screenPoint.toJSONFlutter(), "position": json])
        }
    }

    private func sendOnMapLongPress(screenPoint: CGPoint) {
        if let json = mapView.screen(toLocation: screenPoint).toJSONFlutter() {
            channel.invokeMethod("map#onLongPress", arguments: ["screenPoint": screenPoint.toJSONFlutter(), "position": json])
        }
    }

    private func sendOnMapLongPressEnd(screenPoint: CGPoint) {
        if let json = mapView.screen(toLocation: screenPoint).toJSONFlutter() {
            channel.invokeMethod("map#onLongPressEnd", arguments: ["screenPoint": screenPoint.toJSONFlutter(), "position": json])
        }
    }

    private func sendUserLocationTap() {
        channel.invokeMethod("map#onUserLocationTap", arguments: nil)
    }
}