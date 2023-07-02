//
//  HostingView.swift
//  arcgis_maps_flutter
//
//  Created by Valentin Grigorean on 02.07.2023.
//

import Foundation
import SwiftUI

class HostingView : UIView {
    private var hostingController: UIHostingController<AnyView>?

    func setView(_ view: AnyView) {
        if hostingController == nil {
            hostingController = UIHostingController(rootView: view)
            hostingController?.view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(hostingController!.view)
            NSLayoutConstraint.activate([
                hostingController!.view.leadingAnchor.constraint(equalTo: leadingAnchor),
                hostingController!.view.trailingAnchor.constraint(equalTo: trailingAnchor),
                hostingController!.view.topAnchor.constraint(equalTo: topAnchor),
                hostingController!.view.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        } else {
            hostingController?.rootView = view
        }
    }

    func removeView() {
        hostingController?.view.removeFromSuperview()
        hostingController = nil
    }
}