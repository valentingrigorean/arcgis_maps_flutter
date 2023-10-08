//
//  ArcGISCredentialStoreController.swift
//  arcgis_maps_flutter
//
//  Created by Valentin Grigorean on 06.07.2023.
//

import Foundation
import ArcGIS

extension TokenInfo {
    convenience init?(data: Dictionary<String, Any>) {
        let accessToken = data["accessToken"] as! String
        let expirationDate = data["expirationDate"] as! String
        let isSSLRequired = data["isSSLRequired"] as! Bool
        self.init(accessToken: accessToken, expirationDate: expirationDate.toDateFromIso8601()!, isSSLRequired: isSSLRequired)
    }
}

class ArcGISCredentialStoreController {
    private let taskManager = TaskManager()
    private let channel: FlutterMethodChannel
    private var credentialStore = ArcGISEnvironment.authenticationManager.arcGISCredentialStore
    private var tokenCredentials = [String: ArcGISCredential]()

    init(messenger: FlutterBinaryMessenger) {
        channel = UIFlutterMethodChannel(name: "plugins.flutter.io/arcgis_channel/credential_store", binaryMessenger: messenger)
        channel.setMethodCallHandler({ [weak self](call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            guard let self else {
                return
            }
            self.handle(call: call, result: result)
        })

    }

    deinit {
        channel.setMethodCallHandler(nil)
    }

    private func handle(call: FlutterMethodCall,
                        result: @escaping FlutterResult) -> Void {
        switch (call.method) {
        case "arcGISCredentialStore#makePersistent":
            taskManager.createTask {
                let options = call.arguments as! [String: Any]
                let access = options["access"] as! Int
                let synchronizesWithiCloud = options["synchronizesWithiCloud"] as! Bool
                ArcGISEnvironment.authenticationManager.arcGISCredentialStore = try await .makePersistent(
                        access: self.getKeyAccess(value: access),
                        synchronizesWithiCloud: synchronizesWithiCloud
                )
                self.credentialStore = ArcGISEnvironment.authenticationManager.arcGISCredentialStore
                result(nil)
            }
            break
        case "arcGISCredentialStore#addCredential":
            taskManager.createTask {
                let data = call.arguments as! [String: Any]
                let url = data["url"] as! String
                let username = data["username"] as! String
                let password = data["password"] as! String
                let tokenExpirationMinutes = data["tokenExpirationMinutes"] as? Int

                do {
                    let tokenCredentials = try await TokenCredential.credential(
                            for: URL(string: url)!,
                            username: username,
                            password: password,
                            tokenExpirationMinutes: tokenExpirationMinutes
                    )
                    let uuid = UUID().uuidString
                    self.tokenCredentials[uuid] = tokenCredentials
                    self.credentialStore.add(tokenCredentials)
                    result(uuid)
                } catch {
                    result(error.toJSONFlutter())
                }
            }
            break
        case "arcGISCredentialStore#addPregeneratedTokenCredential":
            let data = call.arguments as! [String: Any]
            let url = data["url"] as! String
            let tokenInfo = TokenInfo(data: data["tokenInfo"] as! Dictionary<String, Any>)!
            let referer = data["referer"] as! String
            let token = PregeneratedTokenCredential(
                    url: URL(string: url)!,
                    tokenInfo: tokenInfo,
                    referer: referer
            )
            credentialStore.add(token)
            let uuid = UUID().uuidString
            tokenCredentials[uuid] = token
            result(uuid)
            break
        case "arcGISCredentialStore#addOAuthCredential":
            let data = call.arguments as! [String: Any]
            let portalUrl = data["portalUrl"] as! String
            let clientID = data["clientId"] as! String
            let redirectURL = data["redirectUri"] as! String
            let configuration = OAuthUserConfiguration(portalURL: URL(string: portalUrl)!, clientID: clientID, redirectURL: URL(string: redirectURL)!)
            taskManager.createTask{
                do {
                    let oAuthCredential = try await OAuthUserCredential.credential(for: configuration)
                    let uuid = UUID().uuidString
                    self.tokenCredentials[uuid] = oAuthCredential
                    self.credentialStore.add(oAuthCredential)
                    result(uuid)
                } catch {
                    result(error.toJSONFlutter())
                }
            }
            break
        case "arcGISCredentialStore#removeCredential":
            let uuid = call.arguments as! String
            let tokenCredential = tokenCredentials[uuid]
            if let tokenCredential = tokenCredential {
                credentialStore.remove(tokenCredential)
                tokenCredentials.removeValue(forKey: uuid)
            }
            result(nil)
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func getKeyAccess(value: Int) -> KeychainAccess {
        switch value {
        case 0:
            return .afterFirstUnlock
        case 1:
            return .afterFirstUnlockThisDeviceOnly
        case 2:
            return .whenUnlocked
        case 3:
            return .whenUnlockedThisDeviceOnly
        case 4:
            return .whenPasscodeSetThisDeviceOnly
        default:
            return .afterFirstUnlock
        }
    }
}
