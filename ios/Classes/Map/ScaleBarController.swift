//
// Created by Valentin Grigorean on 11.07.2021.
//

import Foundation
import ArcGIS
import UIKit


fileprivate let defaultWidth = 175

class ScaleBarController: NSObject {
    private let mapView: MapView
    private let scaleBar: Scalebar

    private let constraintWidth: NSLayoutConstraint
    private let constraintLeft: NSLayoutConstraint
    private let constraintTop: NSLayoutConstraint

    private let constrainXCenter: NSLayoutConstraint
    private let constraintRight: NSLayoutConstraint
    private let constraintBottom: NSLayoutConstraint

    private let allConstraints: [NSLayoutConstraint]

    private let inMapConstraints: [NSLayoutConstraint]

    private let customConstraints: [NSLayoutConstraint]

    private var mapScaleObservation: NSKeyValueObservation?

    private var scaleBarState = ScaleBarState.none

    private var mapScale: Double = 0

    private var autoHide = false
    private var hideAfterMs = 2000

    init(mapView: MapView) {
        self.mapView = mapView
        scaleBar = Scalebar(mapView: mapView)
        scaleBar.mapView = nil
        scaleBar.isHidden = true
        mapView.addSubview(scaleBar)
        scaleBar.translatesAutoresizingMaskIntoConstraints = false

        constraintWidth = scaleBar.widthAnchor.constraint(equalToConstant: CGFloat(defaultWidth))
        constraintLeft = scaleBar.leadingAnchor.constraint(equalTo: mapView.leadingAnchor)
        constraintTop = scaleBar.topAnchor.constraint(equalTo: mapView.topAnchor)

        customConstraints = [constraintWidth, constraintLeft, constraintTop]

        constrainXCenter = scaleBar.centerXAnchor.constraint(equalTo: mapView.centerXAnchor)
        constraintRight = scaleBar.trailingAnchor.constraint(equalTo: mapView.trailingAnchor)
        constraintBottom = scaleBar.bottomAnchor.constraint(equalTo: mapView.attributionTopAnchor, constant: -10)

        inMapConstraints = [constraintWidth, constraintBottom]

        allConstraints = [
            constraintWidth,
            constraintLeft,
            constraintTop,
            constrainXCenter,
            constraintRight,
            constraintBottom
        ]

        super.init()
        bindToMap(map: mapView)
    }

    deinit {
        mapScaleObservation?.invalidate()
        mapScaleObservation = nil

        scaleBar.mapView = nil
    }

    func removeScaleBar() {
        NSLayoutConstraint.deactivate(allConstraints)

        scaleBar.mapView = nil
        scaleBarState = .none
        scaleBar.isHidden = true
    }

    func interpretConfiguration(args: Any?) {
        guard let data = args as? Dictionary<String, Any> else {
            return
        }

        scaleBar.isHidden = false
        scaleBar.mapView = mapView

        let showInMap = data["showInMap"] as! Bool

        validateScaleBarState(isInMap: showInMap)

        if (showInMap) {
            if let inMapAlignment = data["inMapAlignment"] as? Int {
                scaleBar.alignment = toScalebarAlignment(rawValue: inMapAlignment)

                switch scaleBar.alignment {
                case .left:
                    constraintLeft.isActive = true
                    break
                case .right:
                    constraintRight.isActive = true
                    break
                case .center:
                    constrainXCenter.isActive = true
                    break
                }
            }
        } else {

            constraintWidth.constant = CGFloat(min(data["width"] as! Int, defaultWidth))

            if let offsetPoints = data["offset"] as? [Double] {
                constraintLeft.constant = CGFloat(offsetPoints[0])
                constraintTop.constant = CGFloat(offsetPoints[1])
            }
        }

        autoHide = data["autoHide"] as! Bool
        hideAfterMs = data["hideAfter"] as! Int

        if (autoHide) {
            scaleBar.alpha = 0.0
        } else {
            scaleBar.alpha = 1.0
        }

        scaleBar.units = toScalebarUnits(rawValue: data["units"] as! Int)
        scaleBar.style = toScalebarStyle(rawValue: data["style"] as! Int)

        scaleBar.fillColor = UIColor(data: data["fillColor"])
        scaleBar.alternateFillColor = UIColor(data: data["alternateFillColor"])
        scaleBar.lineColor = UIColor(data: data["lineColor"])!
        scaleBar.shadowColor = UIColor(data: data["shadowColor"])
        scaleBar.textColor = UIColor(data: data["textColor"])
        scaleBar.textShadowColor = UIColor(data: data["textShadowColor"])
        scaleBar.font = scaleBar.font.withSize(CGFloat(data["textSize"] as! Int))

        scaleBar.layoutIfNeeded()
    }

    private func handleDidChangeZoom() {
        if scaleBarState == .none {
            return
        }

        if mapView.mapScale == mapScale {
            return
        }

        if (!autoHide) {
            return
        }

        scaleBar.alpha = 1.0

        UIView.animate(withDuration: Double(hideAfterMs) / 1000.0) {
            self.scaleBar.alpha = 0
        }
    }

    private func validateScaleBarState(isInMap: Bool) {
        NSLayoutConstraint.deactivate(allConstraints)
        if (isInMap) {
            constraintLeft.constant = 10
            constraintRight.constant = 10
            constraintWidth.constant = 175

            NSLayoutConstraint.activate(inMapConstraints)
            scaleBarState = .in_map
        } else {
            NSLayoutConstraint.activate(customConstraints)
            scaleBarState = .custom
        }
    }


    private func bindToMap(map: MapView) {
        mapScaleObservation = map.observe(\.mapScale, options: .new) { [weak self] _,
                                                                                   _ in

            DispatchQueue.main.async {
                self?.handleDidChangeZoom()
            }
        }
    }
}


private enum ScaleBarState {
    case none
    case in_map
    case custom
}
