//
// Created by Valentin Grigorean on 16.06.2021.
//

import Foundation
import ArcGIS

extension AGSGeoElement {
    func toJSONFlutter() -> Any {
        let flutterGeometry = try! geometry?.toJSONFlutter()
        return ["geometry": flutterGeometry, "attributes": attributes.toFlutterTypes()]
    }
}
