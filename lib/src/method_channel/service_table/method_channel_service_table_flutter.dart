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
}
