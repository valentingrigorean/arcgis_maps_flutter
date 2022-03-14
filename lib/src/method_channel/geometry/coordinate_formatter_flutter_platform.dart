import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/method_channel/geometry/method_channel_coordinate_formatter_flutter.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class CoordinateFormatterFlutterPlatform extends PlatformInterface {
  static final Object _token = Object();

  static CoordinateFormatterFlutterPlatform _instance =
      MethodChannelCoordinateFormatterFlutter();

  CoordinateFormatterFlutterPlatform() : super(token: _token);

  static CoordinateFormatterFlutterPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [UrlLauncherPlatform] when they register themselves.
  static set instance(CoordinateFormatterFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> latitudeLongitudeString({
    required AGSPoint from,
    required LatitudeLongitudeFormat format,
    required int decimalPlaces,
  }) {
    throw UnimplementedError(
        'latitudeLongitudeString() has not been implemented.');
  }
}
