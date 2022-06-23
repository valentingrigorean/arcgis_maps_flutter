import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/method_channel/tasks/geocode/locator_task_flutter_platform.dart';
import 'package:flutter/services.dart';

class MethodChannelLocatorTaskFlutter extends LocatorTaskFlutterPlatform {
  final MethodChannel _channel =
      const MethodChannel("plugins.flutter.io/arcgis_channel/locator_task");

  @override
  Future<void> createLocatorTask(int id, String url, Credential? credential) {
    return _channel.invokeMethod("createLocatorTask", {
      "id": id,
      "url": url,
      "credential": credential?.toJson(),
    });
  }

  @override
  Future<void> destroyLocatorTask(int id) {
    return _channel.invokeMethod("destroyLocatorTask", id);
  }

  @override
  Future<LocatorInfo> getLocatorInfo(int id) async {
    final result = await _channel.invokeMethod("getLocatorInfo", id);
    return LocatorInfo.fromJson(result);
  }

  @override
  Future<List<GeocodeResult>> reverseGeocode(int id, AGSPoint location) async {
    final List<dynamic> result = await _channel.invokeMethod(
      "reverseGeocode",
      {
        "id": id,
        "location": location.toJson(),
      },
    );
    return result
        .map<GeocodeResult>((json) => GeocodeResult.fromJson(json))
        .toList();
  }
}
