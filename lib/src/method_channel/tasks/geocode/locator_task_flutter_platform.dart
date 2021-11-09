import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/method_channel/tasks/geocode/method_channel_locator_task_flutter.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class LocatorTaskFlutterPlatform extends PlatformInterface {
  static final Object _token = Object();

  static LocatorTaskFlutterPlatform _instance =
      MethodChannelLocatorTaskFlutter();

  LocatorTaskFlutterPlatform() : super(token: _token);

  static LocatorTaskFlutterPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [UrlLauncherPlatform] when they register themselves.
  static set instance(LocatorTaskFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<List<GeocodeResult>> reverseGeocode({
    required String url,
    required AGSPoint location,
    Credential? credential,
  }) {
    throw UnimplementedError('reverseGeocodeAsync() has not been implemented.');
  }
}
