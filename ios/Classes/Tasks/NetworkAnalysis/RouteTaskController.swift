//
// Created by Valentin Grigorean on 28.01.2022.
//

import Foundation
import ArcGIS

class RouteTaskController {
    private let channel: FlutterMethodChannel
    private var routeTasks: [Int: AGSRouteTask] = [:]

    init(messenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(name: "plugins.flutter.io/arcgis_channel/route_task", binaryMessenger: messenger)
        channel.setMethodCallHandler(handle)
    }

    deinit {
        routeTasks = [:]
        channel.setMethodCallHandler(nil)
    }


    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "createRouteTask":
            createRouteTask(data: call.arguments as! [String: Any])
            result(nil)
            break
        case "destroyRouteTask":
            routeTasks.removeValue(forKey: call.arguments as! Int)
            result(nil)
            break
        case "getRouteTaskInfo":
            getRouteTaskInfo(id: call.arguments as! Int, result: result)
            break
        case "createDefaultParameters":
            createDefaultParameters(id: call.arguments as! Int, result: result)
            break
        case "solveRoute":
            solveRoute(data: call.arguments as! [String: Any], result: result)
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }


    private func createRouteTask(data: Dictionary<String, Any>) {
        let routeTask = AGSRouteTask(url: URL(string: data["url"] as! String)!)
        if let credential = data["credential"] as? Dictionary<String, Any> {
            routeTask.credential = AGSCredential(data: credential)
        }
        routeTasks[data["id"] as! Int] = routeTask
    }

    private func getRouteTaskInfo(id: Int, result: @escaping FlutterResult) {
        let routeTask = routeTasks[id]!
        routeTask.load(completion: { (error) in
            if let error = error {
                result(FlutterError(code: "ERROR", message: error.localizedDescription, details: nil))
                return
            }
            result(routeTask.routeTaskInfo().toJSONFlutter())
        })
    }

    private func createDefaultParameters(id: Int, result: @escaping FlutterResult) {
        let routeTask = routeTasks[id]!
        routeTask.defaultRouteParameters(completion: { (defaultParams, error) in
            if let error = error {
                result(FlutterError(code: "ERROR", message: error.localizedDescription, details: nil))
                return
            }
            result(defaultParams!.toJSONFlutter())
        })
    }

    private func solveRoute(data: [String: Any], result: @escaping FlutterResult) {
        let id = data["id"] as! Int
        let parameters = AGSRouteParameters(data: data["parameters"] as! [String: Any])
        let routeTask = routeTasks[id]!
        routeTask.solveRoute(with: parameters, completion: { (routeResult, error) in
            if let error = error {
                result(FlutterError(code: "ERROR", message: error.localizedDescription, details: nil))
                return
            }
            result(routeResult!.toJSONFlutter())
        })
    }
}