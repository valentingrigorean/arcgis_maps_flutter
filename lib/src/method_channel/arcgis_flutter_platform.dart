import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/method_channel/method_channel_arcgis_flutter.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class ArcgisFlutterPlatform extends PlatformInterface {
  static final Object _token = Object();

  static ArcgisFlutterPlatform _instance = MethodChannelArcgisFlutter();

  ArcgisFlutterPlatform() : super(token: _token);

  static ArcgisFlutterPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [UrlLauncherPlatform] when they register themselves.
  static set instance(ArcgisFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> setApiKey(String apiKey) {
    throw UnimplementedError('setApiKey() has not been implemented.');
  }

  Future<String> getApiKey() {
    throw UnimplementedError('getApiKey() has not been implemented.');
  }

  Future<LicenseStatus> setLicense(String licenseKey) {
    throw UnimplementedError('setLicense() has not been implemented.');
  }

  Future<String> getApiVersion() {
    throw UnimplementedError('getApiKey() has not been implemented.');
  }
}
