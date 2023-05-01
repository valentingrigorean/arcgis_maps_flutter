//
//  JobMessage+Flutter.swift
//  arcgis_maps_flutter
//
//  Created by Valentin Grigorean on 01.05.2023.
//

import Foundation
import ArcGIS

extension JobMessage {
    func toJSONFlutter() -> Any {
        [
            "message": text,
            "severity": severity.toFlutterValue(),
            "source": source.toFlutterValue(),
            "timestamp": timestamp.toIso8601String()
        ] as [String : Any]
    }
}
