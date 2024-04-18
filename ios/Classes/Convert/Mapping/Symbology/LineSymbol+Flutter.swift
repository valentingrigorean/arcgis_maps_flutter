//
// Created by Valentin Grigorean on 18.04.2024.
//

import Foundation
import ArcGIS

extension LineSymbol {
      
    func interpretLineSymbol(data:Dictionary<String, Any>){
        if let antialias = data["antialias"] as? Bool {
            self.isAntialiased = antialias
        }

        if let color = data["color"] {
            self.color = UIColor(data: color)!
        }
        
        if let width = data["width"] as? Double{
            self.width = width
        }
    }
}
