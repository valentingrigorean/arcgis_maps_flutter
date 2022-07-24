//
//  ArcGisAuthenticationManager.swift
//  arcgis_maps_flutter
//
//  Created by Mo on 2022/7/18.
//

import Flutter
import ArcGIS

class ArcGisAuthenticationManager : NSObject{

    private let messenger: FlutterBinaryMessenger
    private let methodChannel: FlutterMethodChannel

    open var username: String = ""
    open var password: String = ""

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        methodChannel = FlutterMethodChannel(name: "plugins.flutter.io/arcgis_channel/service_table", binaryMessenger: messenger)
    }


    func setMethodCallHandler(){
        methodChannel.setMethodCallHandler(handle)
    }

    private func handle(_ call: FlutterMethodCall,
                        result: @escaping FlutterResult) -> Void {
        switch (call.method) {
        case "setPersistence":
            guard let data = call.arguments as? Dictionary<String, Any> else {
                result(nil)
                return
            }

            guard let username = data["username"] as? String else {
                result(nil)
                return
            }

            self.username = username

            guard let password = data["password"] as? String else {
                result(nil)
                return
            }

            self.password = password

            AGSAuthenticationManager.shared().delegate = self

            break
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }

//    func authenticationManager(_ authenticationManager: AGSAuthenticationManager, didReceive challenge: AGSAuthenticationChallenge) {
//        let credentials = AGSCredential(user: username, password: password)
//        debugPrint("--> username \(username)  \(password)")
//        challenge.continue(with: credentials)
//    }
}

extension ArcGisAuthenticationManager: AGSAuthenticationManagerDelegate {
    func authenticationManager(_ authenticationManager: AGSAuthenticationManager, didReceive challenge: AGSAuthenticationChallenge) {
        // NOTE: Never hardcode login information in a production application. This is done solely for the sake of the sample.
        let credentials = AGSCredential(user: username, password: password)
        challenge.continue(with: credentials)
    }
}