import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/method_channel/tasks/offline_map/method_channel_offline_map_task_flutter.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class OfflineMapTaskFlutterPlatform extends PlatformInterface {
  static final Object _token = Object();

  static OfflineMapTaskFlutterPlatform _instance =
      MethodChannelOfflineMapTaskFlutter();

  OfflineMapTaskFlutterPlatform() : super(token: _token);

  static OfflineMapTaskFlutterPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [UrlLauncherPlatform] when they register themselves.
  static set instance(OfflineMapTaskFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> createOfflineMapTask(
    int id, {
    ArcGISMap? map,
    PortalItem? portalItem,
  }) {
    throw UnimplementedError(
        'createOfflineMapTask() has not been implemented.');
  }

  Future<void> destroyOfflineMapTask(int id) {
    throw UnimplementedError(
        'destroyOfflineMapTask() has not been implemented.');
  }

  Future<GenerateOfflineMapParameters> defaultGenerateOfflineMapParameters(
    int id, {
    required Geometry areaOfInterest,
    double? minScale,
    double? maxScale,
  }) {
    throw UnimplementedError(
        'defaultGenerateOfflineMapParameters() has not been implemented.');
  }

}
