//
// Created by Valentin Grigorean on 28.11.2022.
//

import Foundation
import ArcGIS

class RouteTaskNativeObject: BaseNativeObject<AGSRouteTask> {
    init(objectId: String, task: AGSRouteTask, messageSink: NativeMessageSink) {
        super.init(objectId: objectId, nativeObject: task, nativeHandlers: [
            LoadableNativeHandler(loadable: task),
            RemoteResourceNativeHandler(remoteResource: task),
            ApiKeyResourceNativeHandler(apiKeyResource: task)
        ], messageSink: messageSink)
    }

    override func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) {
        switch (method) {
        case "routeTask#getRouteTaskInfo":
            getRouteTaskInfo(result: result)
            break
        case "routeTask#createDefaultParameters":
            createDefaultParameters(result: result)
            break
        case "routeTask#solveRoute":
            solveRoute(arguments: arguments, result: result)
            break
        default:
            super.onMethodCall(method: method, arguments: arguments, result: result)
        }
    }

    private func getRouteTaskInfo(result: @escaping FlutterResult) {
        nativeObject.load(completion: { [weak self] (error) in
            if let error = error {
                result(FlutterError(code: "ERROR", message: error.localizedDescription, details: nil))
                return
            }
            result(self?.nativeObject.routeTaskInfo().toJSONFlutter())
        })
    }

    private func createDefaultParameters(result: @escaping FlutterResult) {
        nativeObject.defaultRouteParameters(completion: { (defaultParams, error) in
            if let error = error {
                result(FlutterError(code: "ERROR", message: error.localizedDescription, details: nil))
                return
            }
            result(defaultParams!.toJSONFlutter())
        })
    }

    private func solveRoute(arguments: Any?, result: @escaping FlutterResult) {
        let parameters = AGSRouteParameters(data: arguments as! [String: Any])
        nativeObject.solveRoute(with: parameters, completion: { (routeResult, error) in
            if let error = error {
                result(FlutterError(code: "ERROR", message: error.localizedDescription, details: nil))
                return
            }
            result(routeResult!.toJSONFlutter())
        })
    }

}