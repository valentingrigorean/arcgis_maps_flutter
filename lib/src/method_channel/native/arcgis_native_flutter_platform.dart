import 'package:arcgis_maps_flutter/src/method_channel/native/method_channel_arcgis_native_flutter.dart';
import 'package:arcgis_maps_flutter/src/method_channel/native/native_message.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class ArcgisNativeFlutterPlatform extends PlatformInterface {
  static final Object _token = Object();

  static ArcgisNativeFlutterPlatform _instance =
      MethodChannelArcgisNativeFlutter();

  ArcgisNativeFlutterPlatform() : super(token: _token);

  static ArcgisNativeFlutterPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [UrlLauncherPlatform] when they register themselves.
  static set instance(ArcgisNativeFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Stream<NativeMessage> get onMessage {
    throw UnimplementedError('onMessage() has not been implemented.');
  }

  Future<void> createNativeObject({
    required int objectId,
    required String type,
    dynamic arguments,
  }) {
    throw UnimplementedError('createNativeObject() has not been implemented.');
  }

  Future<void> destroyNativeObject({required int objectId}) {
    throw UnimplementedError('destroyNativeObject() has not been implemented.');
  }

  Future<T?> sendMessage<T>({
    required int objectId,
    required String method,
    dynamic arguments,
  }) {
    throw UnimplementedError('sendMessage() has not been implemented.');
  }
}
