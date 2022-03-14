//
// Created by Valentin Grigorean on 30.03.2021.
//

import Foundation

extension UIImage {

    func colored(_ color: UIColor) -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: size)
            return renderer.image { context in
                color.setFill()
                self.draw(at: .zero)
                context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height), blendMode: .sourceAtop)
            }
        } else {
            // Fallback on earlier versions
            return self
        }
    }

}
