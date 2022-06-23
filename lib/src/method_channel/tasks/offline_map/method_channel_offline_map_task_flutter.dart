import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/method_channel/tasks/offline_map/offline_map_task_flutter_platform.dart';
import 'package:flutter/services.dart';

class MethodChannelOfflineMapTaskFlutter extends OfflineMapTaskFlutterPlatform {
  final MethodChannel _channel =
      const MethodChannel("plugins.flutter.io/arcgis_channel/offline_map_task");

  @override
  Future<void> createOfflineMapTask(
    int id, {
    ArcGISMap? map,
    PortalItem? portalItem,
  }) {
    assert(map != null || portalItem != null);
    return _channel.invokeMethod('createOfflineMapTask', {
      'id': id,
      if (map != null) 'map': map.toJson(),
      if (portalItem != null) 'portalItem': portalItem.toJson(),
    });
  }

  @override
  Future<void> destroyOfflineMapTask(int id) {
    return _channel.invokeMethod('destroyOfflineMapTask', id);
  }

  @override
  Future<GenerateOfflineMapParameters> defaultGenerateOfflineMapParameters(
      int id, {
        required Geometry areaOfInterest,
        double? minScale,
        double? maxScale,
      }) async {
    final result = await _channel.invokeMethod('defaultGenerateOfflineMapParameters', {
      'id': id,
      'areaOfInterest': areaOfInterest.toJson(),
      if(minScale != null) 'minScale': minScale,
      if(maxScale != null) 'maxScale': maxScale,
    });
    return GenerateOfflineMapParameters.fromJson(result);
  }
}
