//
// Created by Valentin Grigorean on 16.06.2021.
//

import Foundation


extension NSNumber {
    var type: CFNumberType {
        CFNumberGetType(self as CFNumber)
    }
}