//
// Created by Valentin Grigorean on 04.04.2024.
//

import Foundation
import ArcGIS

extension MarkerSymbol {

 func interpretMarkerSymbol(data:Dictionary<String, Any>){
  if let angle = data["angle"] as? Double {
   self.angle = Float(angle)
  }
  if let angleAlignment = data["angleAlignment"] as? String {
   self.angleAlignment = SymbolAngleAlignment(name: angleAlignment)
  }
  if let leaderOffset = data["leaderOffset"] as? Array<Double> {
   self.leaderOffsetX = CGFloat(leaderOffset[0])
   self.leaderOffsetY = CGFloat(leaderOffset[1])
  }
  if let offset = data["offset"] as? Array<Double> {
   self.offsetX = CGFloat(offset[0])
   self.offsetY = CGFloat(offset[1])
  }
 }
}