//
// Created by Valentin Grigorean on 20.08.2023.
//

import Foundation
import Flutter

class UIFlutterMethodChannel: FlutterMethodChannel{

    override func invokeMethod(_ method: String, arguments: Any?) {
        if Thread.isMainThread {
            super.invokeMethod(method, arguments: arguments)
        } else {
            DispatchQueue.main.async {
                super.invokeMethod(method, arguments: arguments)
            }
        }
    }

    override func invokeMethod(_ method: String, arguments: Any?, result callback: FlutterResult?) {
        if Thread.isMainThread {
            super.invokeMethod(method, arguments: arguments, result: callback)
        } else {
            DispatchQueue.main.async {
                super.invokeMethod(method, arguments: arguments, result: callback)
            }
        }
    }
}