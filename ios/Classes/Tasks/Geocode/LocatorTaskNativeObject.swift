//
// Created by Valentin Grigorean on 28.11.2022.
//

import Foundation
import ArcGIS

class LocatorTaskNativeObject: BaseNativeObject<LocatorTask> {
    private var suggestResultMap = [String: SuggestResult]()
    
    init(objectId: String, task: LocatorTask, messageSink: NativeMessageSink) {
        super.init(objectId: objectId, nativeObject: task, nativeHandlers: [
            LoadableNativeHandler(loadable: task),
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
        createTask{
            do {
                try await self.nativeObject.load()
                result(self.nativeObject.locatorInfo?.toJSONFlutter())
            } catch {
                result(error.toJSONFlutter())
            }
        }
    }
    
    private func geocode(arguments: Dictionary<String, Any>, result: @escaping FlutterResult) {
        createTask {
            let searchTerm = arguments["searchText"] as! String
            let paramsRaw = arguments["parameters"] as? Dictionary<String, Any>
            let params = paramsRaw == nil ? nil : GeocodeParameters(data: paramsRaw!)
            do {
                let results = try await self.nativeObject.geocode(forSearchText: searchTerm,using:params)
                result(results.map{ $0.toJSONFlutter()})
            }catch{
                result(error.toJSONFlutter())
            }
        }
    }
    
    private func geocodeSuggestResult(arguments: [String: Any], result: @escaping FlutterResult) {
        createTask {
            let suggestResult = self.suggestResultMap[arguments["suggestResultId"] as! String]!
            let paramsRaw = arguments["parameters"] as? Dictionary<String, Any>
            let params = paramsRaw == nil ? nil : GeocodeParameters(data: paramsRaw!)
            do {
                let results = try await self.nativeObject.geocode(forSuggestResult: suggestResult,using:params)
                result(results.map{ $0.toJSONFlutter()})
            }catch{
                result(error.toJSONFlutter())
            }
        }
    }
    
    private func geocodeSearchValues(arguments: [String: Any], result: @escaping FlutterResult) {
        createTask {
            let searchValues = arguments["searchValues"] as! [String: String]
            let paramsRaw = arguments["parameters"] as? Dictionary<String, Any>
            let params = paramsRaw == nil ? nil : GeocodeParameters(data: paramsRaw!)
            do {
                let results = try await self.nativeObject.geocode(forSearchValues: searchValues,using:params)
                result(results.map{ $0.toJSONFlutter()})
            }catch{
                result(error.toJSONFlutter())
            }
        }
    }
    
    private func reverseGeocode(arguments: Dictionary<String, Any>, result: @escaping FlutterResult) {
        createTask {
            let location = Geometry.fromFlutter(data: arguments["location"] as! Dictionary<String, Any>) as! Point
            let paramsRaw = arguments["parameters"] as? Dictionary<String, Any>
            let params = paramsRaw == nil ? nil : ReverseGeocodeParameters(data: paramsRaw!)
            do {
                let results = try await  self.nativeObject.reverseGeocode(forLocation: location,parameters:params)
                result(results.map{ $0.toJSONFlutter()})
            }
            catch{
                result(error.toJSONFlutter())
            }
        }
    }
    
    private func suggest(arguments: Dictionary<String, Any>, result: @escaping FlutterResult) {
        createTask {
            let searchTerm = arguments["searchText"] as! String
            let paramsRaw = arguments["parameters"] as? Dictionary<String, Any>
            let params = paramsRaw == nil ? nil : SuggestParameters(data: paramsRaw!)
            do {
                let results = try await  self.nativeObject.suggest(forSearchText: searchTerm,parameters:params)
                result(results.map{
                    let suggestResultId = UUID().uuidString
                    self.suggestResultMap[suggestResultId] = $0
                    return $0.toJSONFlutter(suggestResultId: suggestResultId)
                })
            }
            catch{
                result(error.toJSONFlutter())
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
