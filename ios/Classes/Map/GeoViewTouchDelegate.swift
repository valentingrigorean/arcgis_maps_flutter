//
//  File.swift
//  arcgis_maps_flutter
//
//  Created by Valentin Grigorean on 03.07.2023.
//

import Foundation
import ArcGIS
import Combine

protocol MapGraphicTouchDelegate: AnyObject {
    func canConsumeTaps() -> Bool

    func didHandleGraphic(graphic: Graphic) -> Bool
}


class GeoViewTouchDelegate {
    private let taskManager = TaskManager()
    private let methodChannel: FlutterMethodChannel
    private let viewModel: MapViewModel
    private var graphicsTouchDelegates = [MapGraphicTouchDelegate]()
    private var cancellables = Set<AnyCancellable>()


    var trackIdentifyLayers: Bool = false

    var trackIdentifyGraphics: Bool = false

    init(methodChannel: FlutterMethodChannel, viewModel: MapViewModel) {
        self.methodChannel = methodChannel
        self.viewModel = viewModel

        viewModel.singleTapEvent.sink(receiveValue: { screenPoint, mapPoint, mapViewProxy in
                    self.taskManager.cancelTask(withKey: "singleTapTask")
                    self.taskManager.createTask(key: "singleTapTask") {
                        await self.handleSingleTap(screenPoint: screenPoint, mapPoint: mapPoint, mapViewProxy: mapViewProxy)
                    }
                })
                .store(in: &cancellables)

        viewModel.longTapEvent.sink(receiveValue: { screenPoint, mapPoint, mapViewProxy in
                    self.taskManager.cancelTask(withKey: "longTapTask")
                    self.taskManager.createTask(key: "longTapTask") {
                        await self.handleLongTap(screenPoint: screenPoint, mapPoint: mapPoint, mapViewProxy: mapViewProxy)
                    }
                })
                .store(in: &cancellables)


        viewModel.longTapEndedEvent.sink(receiveValue: { screenPoint, mapPoint, mapViewProxy in
                    self.taskManager.cancelTask(withKey: "longTapEndedTask")
                    self.taskManager.createTask(key: "longTapEndedTask") {
                        await self.handleLongTapEnded(screenPoint: screenPoint, mapPoint: mapPoint, mapViewProxy: mapViewProxy)
                    }
                })
                .store(in: &cancellables)
    }

    deinit {
        graphicsTouchDelegates.removeAll()
    }


    public func addDelegate(graphicTouchDelegate: MapGraphicTouchDelegate) {
        graphicsTouchDelegates.append(graphicTouchDelegate)
    }

    public func removeDelegate(graphicTouchDelegate: MapGraphicTouchDelegate) {
        graphicsTouchDelegates.removeAll {
            $0 === graphicTouchDelegate
        }
    }


    public func addDelegates(graphicTouchDelegates: [MapGraphicTouchDelegate]) {
        graphicsTouchDelegates.append(contentsOf: graphicTouchDelegates)
    }

    public func removeDelegates(graphicTouchDelegates: [MapGraphicTouchDelegate]) {
        for delegate in graphicTouchDelegates {
            removeDelegate(graphicTouchDelegate: delegate)
        }
    }

    private func handleSingleTap(screenPoint: CGPoint, mapPoint: ArcGIS.Point, mapViewProxy: MapViewProxy) async {

        let result = await withTaskGroup(of: Bool.self) { group in

            if (canConsumeGraphics() || trackIdentifyGraphics) {
                group.addTask {
                    await self.handleIdentifyGraphicsOverlays(screenPoint: screenPoint, mapPoint: mapPoint, mapViewProxy: mapViewProxy)
                }
            }
            if (trackIdentifyLayers) {
                group.addTask {
                    await self.handleIdentifyLayers(screenPoint: screenPoint, mapPoint: mapPoint, mapViewProxy: mapViewProxy)
                }
            }
            for await result in group {
                if result {
                    return true
                }
            }

            return false
        }

        if (result) {
            return
        }


        if let json = mapPoint.toJSONFlutter() {
            methodChannel.invokeMethod("map#onTap", arguments: ["screenPoint": screenPoint.toJSONFlutter(), "position": json])
        }
    }

    private func handleLongTap(screenPoint: CGPoint, mapPoint: ArcGIS.Point, mapViewProxy: MapViewProxy) async {
        if let json = mapPoint.toJSONFlutter() {
            methodChannel.invokeMethod("map#onLongPress", arguments: ["screenPoint": screenPoint.toJSONFlutter(), "position": json])
        }
    }

    private func handleLongTapEnded(screenPoint: CGPoint, mapPoint: ArcGIS.Point, mapViewProxy: MapViewProxy) async {
        if let json = mapPoint.toJSONFlutter() {
            methodChannel.invokeMethod("map#onLongPressEnd", arguments: ["screenPoint": screenPoint.toJSONFlutter(), "position": json])
        }
    }


    private func handleIdentifyGraphicsOverlays(screenPoint: CGPoint, mapPoint: ArcGIS.Point, mapViewProxy: MapViewProxy) async -> Bool {
        do {
            let results = try await mapViewProxy.identifyGraphicsOverlays(screenPoint: screenPoint, tolerance: 12,maximumResultsPerOverlay: trackIdentifyLayers ? nil : 1)
            if trackIdentifyGraphics {
                let flutterIds = getFlutterIds(results: results)
                if !flutterIds.isEmpty {
                    methodChannel.invokeMethod("map#map#onIdentifyGraphics", arguments: ["results": flutterIds, "screenPoint": screenPoint.toJSONFlutter(), "position": mapPoint.toJSONFlutter(), "flutterIds": flutterIds])
                }
            }
            return onTapGraphicsCompleted(results: results, screenPoint: screenPoint)
        } catch {
            return false
        }
    }

    private func handleIdentifyLayers(screenPoint: CGPoint, mapPoint: ArcGIS.Point, mapViewProxy: MapViewProxy) async -> Bool {
        do {
            let results = try await mapViewProxy.identifyLayers(screenPoint: screenPoint, tolerance: 12)
            if results.isEmpty {
                return false
            }
            var isEmpty = true;
            for result in results {
                if !result.geoElements.isEmpty {
                    isEmpty = false
                    break
                }
            }
            if isEmpty {
                return false
            }
            methodChannel.invokeMethod("map#onIdentifyLayers", arguments: ["results": results.toJSONFlutter(), "screenPoint": screenPoint.toJSONFlutter(), "position": mapPoint.toJSONFlutter()])
        } catch {
            return false
        }
        return true
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

    private func getFlutterIds(results: [ArcGIS.IdentifyGraphicsOverlayResult]) -> [String] {
        var flutterIds = [String]()
        for result in results {
            for graphic in result.graphics {
                if let markerId = graphic.attributes["markerId"] as? String {
                    flutterIds.append(markerId)
                    continue
                }
                if let polylineId = graphic.attributes["polylineId"] as? String {
                    flutterIds.append(polylineId)
                    continue
                }
                if let polygonId = graphic.attributes["polygonId"] as? String {
                    flutterIds.append(polygonId)
                    continue
                }
            }
        }
        return flutterIds
    }

    private func sendOnMapTap(screenPoint: CGPoint, mapViewProxy: MapViewProxy) {
        if let json = mapViewProxy.location(fromScreenPoint: screenPoint)?.toJSONFlutter() {
            methodChannel.invokeMethod("map#onTap", arguments: ["screenPoint": screenPoint.toJSONFlutter(), "position": json])
        }
    }
}
