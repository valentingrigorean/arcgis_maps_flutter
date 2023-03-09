import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel_service_table_flutter.dart';

abstract class ServiceTableFlutterPlatform extends PlatformInterface {
  static final Object _token = Object();

  static ServiceTableFlutterPlatform _instance =
      MethodChannelServiceTableFlutter();

  ServiceTableFlutterPlatform() : super(token: _token);

  static ServiceTableFlutterPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [UrlLauncherPlatform] when they register themselves.
  static set instance(ServiceTableFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<List<Feature>> queryFeatures(
      String url, QueryParameters queryParameters,
      {FeatureTableQueryFeatureFields queryFields =
          FeatureTableQueryFeatureFields.loadAll}) {
    throw UnimplementedError('queryFeatures() has not been implemented.');
  }

  Future<StatisticResult> queryStatisticsAsync(
      String url, StatisticsQueryParameters statisticsQueryParameters) {
    throw UnimplementedError('queryStatisticsAsync() has not been implemented.');
  }

  Future<num> queryFeatureCount(
      String url, QueryParameters queryParameters) {
    throw UnimplementedError('queryFeatureCount() has not been implemented.');
  }
}
