//
// Created by Valentin Grigorean on 28.01.2022.
//

import Foundation
import ArcGIS

class RouteTaskController{
    private let channel: FlutterMethodChannel
    private var locatorTasks: [Int: AGSRouteTask] = [:]

    init(messenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(name: "plugins.flutter.io/route_task", binaryMessenger: messenger)
        //channel.setMethodCallHandler(handle)
    }
}