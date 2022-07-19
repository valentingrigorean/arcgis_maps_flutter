//
//  ArcGisMeasureHelper.swift
//  arcgis_maps_flutter
//
//  Created by Mo on 2022/7/18.
//
protocol ArcGisMeasureHelper {
    func initMeasure()
    func reset()
    func clear() -> Double
    func revoke() -> Double
    func makePoint() -> Double
}
