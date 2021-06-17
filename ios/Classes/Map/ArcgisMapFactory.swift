//
// Created by Valentin Grigorean on 23.03.2021.
//

import Foundation

public class ArcgisMapFactory: NSObject, FlutterPlatformViewFactory {

    private let registrar: FlutterPluginRegistrar

    public init(registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
        super.init()
    }


    public func create(withFrame frame: CGRect,
                       viewIdentifier viewId: Int64,
                       arguments args: Any?) -> FlutterPlatformView {
        ArcgisMapController(withRegistrar: registrar, withFrame: frame, viewIdentifier: viewId, arguments: args)
    }

    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec(readerWriter: FlutterStandardReaderWriter())
    }
}