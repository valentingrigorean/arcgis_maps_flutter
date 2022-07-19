//
//  DistanceMeasureHelper.swift
//  arcgis_maps_flutter
//
//  Created by Mo on 2022/7/18.
//

import Foundation
import ArcGIS

class DistanceMeasureHelperImpl: ArcGisMeasureHelper {
    init(mapView: AGSMapView) {
        self.mapView = mapView
        path.symbol = AGSSimpleLineSymbol(style: AGSSimpleLineSymbolStyle.dash, color: UIColor(red: 0, green: 0, blue: 255, alpha: 0), width: 5)
    }


    private let mapView: AGSMapView

    private let unitOfMeasurement = AGSLinearUnit(unitID: .meters)

    private let centerMarker = AGSSimpleMarkerSymbol(style: .cross, color: UIColor(red: 156, green: 39, blue: 176, alpha: 0), size: 10)

    private let graphicOverlay = AGSGraphicsOverlay()

    private let locationMaker = AGSSimpleMarkerSymbol(style: .circle, color: UIColor(red: 55, green: 0, blue: 179, alpha: 0), size: 8)

    private let path = AGSGraphic()

    private var polylinePoints: [AGSPoint] = []
    private var polylineGraphicList: [AGSGraphic] = []
    private var locationPointGraphicList: [AGSGraphic] = [];

    private var measureEnabled = false

    func initMeasure() {
        mapView.graphicsOverlays.add(graphicOverlay)
        measureEnabled = true
    }

    private func viewpointChangedHandler() {

    }

    func reset() {
        measureEnabled = false
        path.geometry = nil
        graphicOverlay.graphics.remove(graphicOverlay)
        graphicOverlay.graphics.removeObjects(in: polylineGraphicList)
        graphicOverlay.graphics.removeObjects(in: locationPointGraphicList)
        polylineGraphicList.removeAll()
        polylinePoints.removeAll()
        mapView.graphicsOverlays.remove(graphicOverlay)
    }

    func clear() -> Double {
        graphicOverlay.graphics.removeObjects(in: polylineGraphicList)
        graphicOverlay.graphics.removeObjects(in: locationPointGraphicList)
        polylineGraphicList.removeAll()
        polylinePoints.removeAll()
        return 0
    }

    func revoke() -> Double {
        graphicOverlay.graphics.removeObjects(in: polylineGraphicList)
        graphicOverlay.graphics.removeObjects(in: locationPointGraphicList)
        polylineGraphicList.removeAll()
        if polylinePoints.isEmpty {
            return 0
        }
        polylinePoints.remove(at: (polylinePoints.count - 1))

        return drawPolyline(points: polylinePoints)
    }

    func makePoint() -> Double {
        graphicOverlay.graphics.removeObjects(in: polylineGraphicList)
        graphicOverlay.graphics.removeObjects(in: locationPointGraphicList)
        let centerPoint = mapView.visibleArea?.extent.center
        if let point = centerPoint {
            polylinePoints.append(point)
        }

        return drawPolyline(points: polylinePoints)
    }

    private func drawPolyline(points: [AGSPoint]) -> Double {
        var result = 0.0
        locationPointGraphicList.removeAll()
        let graphicPoints = points.map { point -> AGSGraphic in
            let graphic = AGSGraphic()
            graphic.symbol = locationMaker
            graphic.geometry = AGSGeometryEngine.projectGeometry(point, to: .wgs84())
            locationPointGraphicList.append(graphic)
            return graphic
        }

        graphicOverlay.graphics.addObjects(from: graphicPoints)

        let polylineSymbol = AGSSimpleLineSymbol(style: .solid, color: UIColor(red: 55, green: 0, blue: 179, alpha: 0), width: 3)
        if graphicPoints.count > 1 {
            let polyline = AGSPolyline(points: polylinePoints)
            let polylineGraphic = AGSGraphic(geometry: polyline, symbol: polylineSymbol)
            polylineGraphicList.append(polylineGraphic)
            graphicOverlay.graphics.add(polylineGraphic)
            let pathGeometry = AGSGeometryEngine.geodeticDensifyGeometry(polyline, maxSegmentLength: 1, lengthUnit: .meters(), curveType: .geodesic)
            if let pg = pathGeometry {
                result = AGSGeometryEngine.geodeticLength(of: pg, lengthUnit: .meters(), curveType: .geodesic)
            }
        }
        return result
    }

}