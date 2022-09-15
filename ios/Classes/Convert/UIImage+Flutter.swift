//
// Created by Valentin Grigorean on 03.08.2022.
//

import Foundation

extension UIImage {
    func toJSONFlutter() -> Any? {
        if let data = pngData() {
            return FlutterStandardTypedData(bytes: data)
        }
        return nil
    }
}