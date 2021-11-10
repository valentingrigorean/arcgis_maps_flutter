//
// Created by Valentin Grigorean on 09.11.2021.
//

import Foundation
import ArcGIS

class LocatorTaskController {
    private let channel: FlutterMethodChannel
    private var locatorTasks: [Int: AGSLocatorTask] = [:]

    init(messenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(name: "plugins.flutter.io/locator_task", binaryMessenger: messenger)
        channel.setMethodCallHandler(handle)
    }

    deinit {
        channel.setMethodCallHandler(nil)
    }

    private func handle(_ call: FlutterMethodCall,
                        result: @escaping FlutterResult) -> Void {

        switch (call.method) {
        case "createLocatorTask":
            createLocatorTask(data: call.arguments as! [String: Any])
            result(nil)
            break
        case "destroyLocatorTask":
            locatorTasks.removeValue(forKey: call.arguments as! Int)
            result(nil)
            break
        case "getLocatorInfo":
            getLocatorInfo(id: call.arguments as! Int, result: result)
            break
        case "reverseGeocode":
            reverseGeocode(data: call.arguments as! [String: Any], result: result)
            break
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }

    private func getLocatorInfo(id:Int, result: @escaping FlutterResult) {
        let locatorTask = locatorTasks[id]!
        locatorTask.load(completion: { [weak self] (error) in
            guard let self = self else { return }
            if let error = error {
                result(FlutterError(code: "ERROR", message: error.localizedDescription, details: nil))
                return
            }
            result(locatorTask.locatorInfo?.toJSONFlutter())
        })
    }


    private func reverseGeocode(data: Dictionary<String, Any>, result: @escaping FlutterResult) {
        let locatorTask = locatorTasks[data["id"] as! Int]!
        let location = AGSGeometry.fromFlutter(data: data["location"] as! Dictionary<String, Any>) as! AGSPoint
        let callback = result

      locatorTask.reverseGeocode(withLocation: location) { [weak self] (results, error) in
            if let error = error {
                callback(FlutterError(code: "ERROR", message: error.localizedDescription, details: nil))
            } else {
                if let results = results {
                    let result = results.map {
                        $0.toJSONFlutter()
                    }
                    callback(result)
                } else {
                    callback([])
                }
            }
        }
    }

    private func createLocatorTask(data: Dictionary<String, Any>) {
        let locatorTask = AGSLocatorTask(url: URL(string: data["url"] as! String)!)
        if let credential = data["credential"] as? Dictionary<String, Any> {
            locatorTask.credential = AGSCredential(data: credential)
        }
        locatorTasks[data["id"] as! Int] = locatorTask
    }
}