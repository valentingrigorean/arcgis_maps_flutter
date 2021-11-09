import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/method_channel/tasks/geocode/locator_task_flutter_platform.dart';
import 'package:flutter/services.dart';

class MethodChannelLocatorTaskFlutter extends LocatorTaskFlutterPlatform {
  final MethodChannel _channel =
      const MethodChannel("plugins.flutter.io/locator_task");

  @override
  Future<List<GeocodeResult>> reverseGeocode({
    required String url,
    required AGSPoint location,
    Credential? credential,
  }) async {
    final result =
        await _channel.invokeMethod<List<dynamic>>("reverseGeocode", {
      "url": url,
      "location": location.toJson(),
      if (credential != null) "credential": credential!.toJson(),
    });
    if (result == null) {
      return const [];
    }
    return result
        .map<GeocodeResult>((json) => GeocodeResult.fromJson(json))
        .toList();
  }
}
