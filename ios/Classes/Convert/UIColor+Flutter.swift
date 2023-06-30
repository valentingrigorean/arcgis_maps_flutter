//
// Created by Valentin Grigorean on 30.03.2021.
//

import Foundation
import SwiftUI

extension UIColor {
    convenience init?(data: Any?) {
        guard let value = data as? CUnsignedLong else {
            return nil
        }
        self.init(red: CGFloat(Float(((value & 0xFF0000) >> 16)) / 255.0),
                green: CGFloat(Float(((value & 0xFF00) >> 8)) / 255.0),
                blue: CGFloat(Float(((value & 0xFF))) / 255.0),
                alpha: CGFloat(Float(((value & 0xFF000000) >> 24)) / 255.0))
    }
    
    
    func toSwiftUIColor() -> Color {
        Color(self)
    }
}
