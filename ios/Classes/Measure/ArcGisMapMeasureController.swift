//
//  ArcGisMapMeasureController.swift
//  arcgis_maps_flutter
//
//  Created by Mo on 2022/7/18.
//

import Foundation
import ArcGIS
import Flutter

class ArcGisMapMeasureController {
    init(mapView: AGSMapView) {
        self.mapView = mapView
        distanceMeasure = DistanceMeasureHelperImpl(mapView: self.mapView)
        areaMeasure = AreaMeasureHelperImpl(mapView: self.mapView)
    }

    private let mapView: AGSMapView
    private let distanceMeasure: ArcGisMeasureHelper
    private let areaMeasure: ArcGisMeasureHelper

    func onDistanceMeasure(action: String, result: @escaping FlutterResult) {
        onMeasure(measureHelper: distanceMeasure, action: action, result: result)
    }


    func onAreaMeasure(action: String, result: @escaping FlutterResult) {
        onMeasure(measureHelper: distanceMeasure, action: action, result: result)
    }

    private func onMeasure(measureHelper: ArcGisMeasureHelper, action: String, result: @escaping FlutterResult) {
        if ("enter" == action) {
            measureHelper.initMeasure()
            result(0.0)
        } else if ("makePoint" == action) {
            result(measureHelper.makePoint())
        } else if ("revoke" == action) {
            result(measureHelper.revoke())
        } else if ("clear" == action) {
            result(measureHelper.clear())
        } else if ("exit" == action) {
            measureHelper.reset()
            result(0.0)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
}