//
// Created by Valentin Grigorean on 28.11.2022.
//

import Foundation
import ArcGIS

class LocatorTaskNativeObject: BaseNativeObject<AGSLocatorTask> {
    init(objectId: String, task: AGSLocatorTask, messageSink: NativeMessageSink) {
        super.init(objectId: objectId, nativeObject: task, nativeHandlers: [
            LoadableNativeHandler(loadable: task),
            RemoteResourceNativeHandler(remoteResource: task),
            ApiKeyResourceNativeHandler(apiKeyResource: task)
        ], messageSink: messageSink)
    }

    override func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) {
        switch (method) {
        case "locatorTask#getLocatorInfo":
            getLocatorInfo(result: result)
            break
        case "locatorTask#geocode":
            geocode(arguments: arguments as! Dictionary<String, Any>, result: result)
            break
        case "locatorTask#reverseGeocode":
            reverseGeocode(arguments: arguments, result: result)
            break
        default:
            super.onMethodCall(method: method, arguments: arguments, result: result)
        }
    }

    private func getLocatorInfo(result: @escaping FlutterResult) {
        nativeObject.load(completion: { [weak self] (error) in
            if let error = error {
                result(FlutterError(code: "ERROR", message: error.localizedDescription, details: nil))
                return
            }
            result(self?.nativeObject.locatorInfo?.toJSONFlutter())
        })
    }

    private func geocode(arguments: Dictionary<String, Any>, result: @escaping FlutterResult) {
        let searchTerm = arguments["searchText"] as! String
        let callback = result
        if let params = arguments["params"] as? Dictionary<String, Any> {
            let geocodeParameters = AGSGeocodeParameters(data: params)
            nativeObject.geocode(withSearchText: searchTerm, parameters: geocodeParameters) { (results, error) in
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
        } else {
            nativeObject.geocode(withSearchText: searchTerm) { (results, error) in
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
    }

    private func reverseGeocode(arguments: Any?, result: @escaping FlutterResult) {
        let location = AGSGeometry.fromFlutter(data: arguments as! Dictionary<String, Any>) as! AGSPoint
        let callback = result

        nativeObject.reverseGeocode(withLocation: location) { (results, error) in
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
}