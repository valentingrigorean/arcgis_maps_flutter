//
//  AreaMeasureHelper.swift
//  arcgis_maps_flutter
//
//  Created by Mo on 2022/7/18.
//

import Foundation
import ArcGIS

class AreaMeasureHelperImpl: ArcGisMeasureHelper {
    init(mapView: AGSMapView) {
        self.mapView = mapView
        path.symbol = AGSSimpleLineSymbol(style: .dash, color: UIColor(red: 0, green: 0, blue: 1, alpha: 1), width: 5)
        polygonFillSymbol = AGSSimpleFillSymbol(style: .solid, color: UIColor(red: 0, green: 1, blue: 0, alpha: 0.5), outline: polygonOutlineSymbol)
    }

    private let graphicOverlay = AGSGraphicsOverlay()

    private let locationMaker = AGSSimpleMarkerSymbol(style: .circle, color: UIColor(red: 0.21, green: 0, blue: 0.70, alpha: 1), size: 8)

    private let path = AGSGraphic()

    private let polygonSymbol = AGSSimpleLineSymbol(style: .dash, color: UIColor(red: 0, green: 0, blue: 1, alpha: 1), width: 5)
    private let polygonOutlineSymbol = AGSSimpleLineSymbol(style: .solid, color: UIColor(red: 0.21, green: 0, blue: 0.70, alpha: 1), width: 2)
    private let polygonFillSymbol: AGSSimpleFillSymbol
    private let polygonGeometry = AGSPolygonBuilder(spatialReference: .webMercator())

    private var polygonPoints: [AGSPoint] = []
    private var polygonGraphicList: [AGSGraphic] = []
    private var locationPointGraphicList: [AGSGraphic] = []

    private let mapView: AGSMapView
    private var measureEnabled = false

    func initMeasure() {
        mapView.graphicsOverlays.add(graphicOverlay)
        measureEnabled = true
    }

    func reset() {
        measureEnabled = false
        path.geometry = nil
        mapView.graphicsOverlays.remove(graphicOverlay)
        graphicOverlay.graphics.removeObjects(in: polygonGraphicList)
        graphicOverlay.graphics.removeObjects(in: locationPointGraphicList)
        polygonGraphicList.removeAll()
        polygonPoints.removeAll()
    }

    func clear() -> Double {
        graphicOverlay.graphics.removeObjects(in: polygonGraphicList)
        graphicOverlay.graphics.removeObjects(in: locationPointGraphicList)
        polygonGraphicList.removeAll()
        polygonPoints.removeAll()
        return 0
    }

    func revoke() -> Double {
        graphicOverlay.graphics.removeObjects(in: polygonGraphicList)
        graphicOverlay.graphics.removeObjects(in: locationPointGraphicList)
        if polygonPoints.isEmpty {
            return 0
        }
        polygonPoints.remove(at: (polygonPoints.count - 1))
        return drawPolygon(points: polygonPoints)
    }

    func makePoint() -> Double {
        graphicOverlay.graphics.removeObjects(in: polygonGraphicList)
        graphicOverlay.graphics.removeObjects(in: locationPointGraphicList)
        let centerPoint = mapView.visibleArea?.extent.center
        if let point = centerPoint {
            polygonPoints.append(point)
        }
        return drawPolygon(points: polygonPoints)
    }

    private func drawPolygon(points: [AGSPoint]) -> Double {
        var result: Double = 0.0
        locationPointGraphicList.removeAll()
        let graphicPoints = points.map { point -> AGSGraphic in
            let graphic = AGSGraphic()
            graphic.symbol = locationMaker
            graphic.geometry = AGSGeometryEngine.projectGeometry(point, to: .wgs84())
            locationPointGraphicList.append(graphic)
            return graphic
        }

        graphicOverlay.graphics.addObjects(from: graphicPoints)

        if (graphicPoints.count > 1) {
            let polygon = AGSPolygon(points: points)
            let polylineGraphic = AGSGraphic(geometry: polygon, symbol: polygonFillSymbol)
            polygonGraphicList.append(polylineGraphic)
            graphicOverlay.graphics.add(polylineGraphic)

            let pathGeometry = AGSGeometryEngine.geodeticDensifyGeometry(polygon, maxSegmentLength: 1, lengthUnit: .meters(), curveType: .geodesic)
            if let pg = pathGeometry {
                result = AGSGeometryEngine.geodeticArea(of: pg, areaUnit: .squareMeters(), curveType: .geodesic)
            }
        }

        return result

    }

}