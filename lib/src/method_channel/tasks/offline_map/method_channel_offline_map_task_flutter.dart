import 'dart:async';

import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/method_channel/tasks/offline_map/offline_map_task_flutter_platform.dart';
import 'package:flutter/services.dart';

int _jobHandlerId = 0;

class MethodChannelOfflineMapTaskFlutter extends OfflineMapTaskFlutterPlatform {
  final MethodChannel _channel =
      const MethodChannel("plugins.flutter.io/arcgis_channel/offline_map_task");

  @override
  Future<void> createOfflineMapTask(
    int id, {
    ArcGISMap? map,
    PortalItem? portalItem,
    Credential? credential,
  }) {
    assert(map != null || portalItem != null);
    return _channel.invokeMethod('createOfflineMapTask', {
      'id': id,
      if (map != null) 'map': map.toJson(),
      if (portalItem != null) 'portalItem': portalItem.toJson(),
      if (credential != null) 'credential': credential.toJson(),
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
    final result =
        await _channel.invokeMethod('defaultGenerateOfflineMapParameters', {
      'id': id,
      'areaOfInterest': areaOfInterest.toJson(),
      if (minScale != null) 'minScale': minScale,
      if (maxScale != null) 'maxScale': maxScale,
    });
    return GenerateOfflineMapParameters.fromJson(result);
  }

  @override
  Future<GenerateOfflineMapJob> generateOfflineMap(
    int id, {
    required GenerateOfflineMapParameters parameters,
    required String downloadDirectory,
  }) async {
    final jobId = _jobHandlerId++;
    final result = await _channel.invokeMethod('generateOfflineMap', {
      'id': id,
      'jobId': jobId,
      'parameters': parameters.toJson(),
      'downloadDirectory': downloadDirectory,
    });
  }
}
