//
// Created by Valentin Grigorean on 28.11.2022.
//

import Foundation
import ArcGIS

class RouteTaskNativeObject: BaseNativeObject<RouteTask> {
    init(objectId: String, task: RouteTask, messageSink: NativeMessageSink) {
        super.init(objectId: objectId, nativeObject: task, nativeHandlers: [
            LoadableNativeHandler(loadable: task),
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
        createTask {
            do {
                try await self.nativeObject.load()
                result(self.nativeObject.info.toJSONFlutter())
            } catch {
                result(error.toJSONFlutter())
            }
        }
    }

    private func createDefaultParameters(result: @escaping FlutterResult) {
        createTask {
            do {
                let params = try await self.nativeObject.makeDefaultParameters()
                result(params.toJSONFlutter())
            } catch {
                result(error.toJSONFlutter())
            }
        }
    }

    private func solveRoute(arguments: Any?, result: @escaping FlutterResult) {
        createTask {
            do {
                let parameters = RouteParameters(data: arguments as! [String: Any])
                let route = try await self.nativeObject.solveRoute(using: parameters)
                result(route.toJSONFlutter())
            } catch {
                result(error.toJSONFlutter())
            }
        }
    }
}
