//
// Created by Valentin Grigorean on 11.07.2021.
//

import Foundation
import ArcGIS

extension LoadStatus{
    func toFlutterValue() -> Int{
        switch self {
        case .notLoaded:
            return 0
        case .loading:
            return 1
        case .loaded:
            return 2
        case .failed:
            return 3
        }
    }
}

extension UnitSystem {

    init(_ flutterValue:Int){
        switch flutterValue{
        case 0:
            self = .imperial
        case 1:
            self = .metric
        default:
            fatalError("Invalid UnitSystem type \(flutterValue)")
        }
    }

    func toFlutterValue()->Int{
        switch self{
        case .imperial:
            return 0
        case .metric:
            return 1
        default:
            fatalError("Invalid UnitSystem type \(self)")
        }
    }
}