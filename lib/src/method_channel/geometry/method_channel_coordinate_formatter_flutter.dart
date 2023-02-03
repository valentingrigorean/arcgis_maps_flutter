import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/method_channel/geometry/coordinate_formatter_flutter_platform.dart';
import 'package:flutter/services.dart';

class MethodChannelCoordinateFormatterFlutter
    extends CoordinateFormatterFlutterPlatform {
  final MethodChannel _channel =
      const OptionalMethodChannel("plugins.flutter.io/arcgis_channel/coordinate_formatter");

  @override
  Future<String?> latitudeLongitudeString({
    required AGSPoint from,
    required LatitudeLongitudeFormat format,
    required int decimalPlaces,
  }) async {
    return _channel.invokeMethod('latitudeLongitudeString', {
      "from": from.toJson(),
      "format": format.index,
      "decimalPlaces": decimalPlaces,
    });
  }
}
