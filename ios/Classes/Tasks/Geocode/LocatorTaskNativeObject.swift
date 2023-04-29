//
// Created by Valentin Grigorean on 28.11.2022.
//

import Foundation
import ArcGIS

class LocatorTaskNativeObject: BaseNativeObject<AGSLocatorTask> {
    private var suggestResultMap = [String: AGSSuggestResult]()

    init(objectId: String, task: AGSLocatorTask, messageSink: NativeMessageSink) {
        super.init(objectId: objectId, nativeObject: task, nativeHandlers: [
            LoadableNativeHandler(loadable: task),
            RemoteResourceNativeHandler(remoteResource: task),
            ApiKeyResourceNativeHandler(apiKeyResource: task)
        ], messageSink: messageSink)
    }

    override func dispose() {
        super.dispose()
        suggestResultMap.removeAll()
    }

    override func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) {
        switch (method) {
        case "locatorTask#getLocatorInfo":
            getLocatorInfo(result: result)
            break
        case "locatorTask#geocode":
            geocode(arguments: arguments as! Dictionary<String, Any>, result: result)
            break
        case "locatorTask#geocodeSuggestResult":
            geocodeSuggestResult(arguments: arguments as! Dictionary<String, Any>, result: result)
            break
        case "locatorTask#geocodeSearchValues":
            geocodeSearchValues(arguments: arguments as! Dictionary<String, Any>, result: result)
            break
        case "locatorTask#reverseGeocode":
            reverseGeocode(arguments: arguments as! Dictionary<String, Any>, result: result)
            break
        case "locatorTask#suggest":
            suggest(arguments: arguments as! Dictionary<String, Any>, result: result)
            break
        case "locatorTask#releaseSuggestResults":
            releaseSuggestResults(arguments: arguments)
            result(nil)
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
        if let params = arguments["parameters"] as? Dictionary<String, Any> {
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

    private func geocodeSuggestResult(arguments: [String: Any], result: @escaping FlutterResult) {
        let suggestResult = suggestResultMap[arguments["suggestResultId"] as! String]!
        let callback = result
        if let params = arguments["parameters"] as? Dictionary<String, Any> {
            let geocodeParameters = AGSGeocodeParameters(data: params)
            nativeObject.geocode(with: suggestResult, parameters: geocodeParameters) { (results, error) in
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
            nativeObject.geocode(with: suggestResult) { (results, error) in
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

    private func geocodeSearchValues(arguments: [String: Any], result: @escaping FlutterResult) {
        let searchValues = arguments["searchValues"] as! [String: String]
        let callback = result
        if let params = arguments["parameters"] as? Dictionary<String, Any> {
            let geocodeParameters = AGSGeocodeParameters(data: params)
            nativeObject.geocode(withSearchValues: searchValues, parameters: geocodeParameters) { (results, error) in
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
            nativeObject.geocode(withSearchValues: searchValues) { (results, error) in
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

    private func reverseGeocode(arguments: Dictionary<String, Any>, result: @escaping FlutterResult) {
        let location = AGSGeometry.fromFlutter(data: arguments["location"] as! Dictionary<String, Any>) as! Point
        let callback = result

        if let params = arguments["parameters"] as? Dictionary<String, Any> {
            let reverseGeocodeParameters = AGSReverseGeocodeParameters(data: params)
            nativeObject.reverseGeocode(withLocation: location, parameters: reverseGeocodeParameters) { (results, error) in
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

    private func suggest(arguments: Dictionary<String, Any>, result: @escaping FlutterResult) {
        let searchTerm = arguments["searchText"] as! String
        let callback = result
        if let params = arguments["parameters"] as? Dictionary<String, Any> {
            let suggestParameters = AGSSuggestParameters(data: params)
            nativeObject.suggest(withSearchText: searchTerm, parameters: suggestParameters) { (results, error) in
                if let error = error {
                    callback(FlutterError(code: "ERROR", message: error.localizedDescription, details: nil))
                } else {
                    if let results = results {
                        let result = results.map {
                            let suggestResultId = UUID().uuidString
                            self.suggestResultMap[suggestResultId] = $0
                            return $0.toJSONFlutter(suggestResultId: suggestResultId)
                        }
                        callback(result)
                    } else {
                        callback([])
                    }
                }
            }
        } else {
            nativeObject.suggest(withSearchText: searchTerm) { (results, error) in
                if let error = error {
                    callback(FlutterError(code: "ERROR", message: error.localizedDescription, details: nil))
                } else {
                    if let results = results {
                        let result = results.map {
                            let suggestResultId = UUID().uuidString
                            self.suggestResultMap[suggestResultId] = $0
                            return $0.toJSONFlutter(suggestResultId: suggestResultId)
                        }
                        callback(result)
                    } else {
                        callback([])
                    }
                }
            }
        }
    }

    private func releaseSuggestResults(arguments: Any?) {
        if arguments == nil {
            suggestResultMap.removeAll()
        } else {
            let tags = arguments as! [String]
            for tag in tags {
                suggestResultMap.removeValue(forKey: tag)
            }
        }
    }
}
