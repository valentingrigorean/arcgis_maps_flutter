import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/services.dart';

import 'service_table_flutter_platform.dart';

class MethodChannelServiceTableFlutter extends ServiceTableFlutterPlatform {
  final MethodChannel _channel =
      const MethodChannel("plugins.flutter.io/service_table");

  @override
  Future<List<Feature>> queryFeatures(
      String url, QueryParameters queryParameters,
      {FeatureTableQueryFeatureFields queryFields =
          FeatureTableQueryFeatureFields.loadAll}) async {
     Map<dynamic,dynamic> results = await _channel.invokeMethod("queryFeatures", {
      "url": url,
      "queryParameters": queryParameters.toJson(),
      "queryFields": queryFields.name
    });
     List<dynamic> features = results["features"];
    return features.map((e) => Feature.fromJson(e)).toList();
  }

  @override
  Future<StatisticResult> queryStatisticsAsync(String url, StatisticsQueryParameters statisticsQueryParameters) async{
    Map<dynamic,dynamic> result = await _channel.invokeMethod("queryStatisticsAsync", {
      "url": url,
      "statisticsQueryParameters": statisticsQueryParameters.toJson()
    });

    return StatisticResult.fromJson(result);
  }

  @override
  Future<num> queryFeatureCount(
      String url, QueryParameters queryParameters) async {
    Map<dynamic,dynamic> results = await _channel.invokeMethod("queryFeatureCount", {
      "url": url,
      "queryParameters": queryParameters.toJson(),
    });
    return results["count"];
  }
}
