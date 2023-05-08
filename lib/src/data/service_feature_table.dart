part of arcgis_maps_flutter;

enum FeatureTableQueryFeatureFields {
  idsOnly(0),
  minimum(1),
  loadAll(2);

  const FeatureTableQueryFeatureFields(this.value);

  final int value;
}

class ServiceFeatureTable extends ArcgisNativeObject
    with ApiKeyResource, Loadable {
  final String _uri;

  ServiceFeatureTable.fromUri(this._uri);

  @protected
  @override
  dynamic getCreateArguments() => _uri;

  @override
  String get type => 'ServiceFeatureTable';

  Future<List<Feature>> queryFeatures({
    required QueryParameters queryParameters,
    FeatureTableQueryFeatureFields queryFields =
        FeatureTableQueryFeatureFields.loadAll,
  }) async {
    final features = await invokeMethod<List<dynamic>>(
        'serviceFeatureTable#queryFeatures',
        arguments: {
          "queryParameters": queryParameters.toJson(),
          "queryFields": queryFields.value,
        });
    return features?.map((e) => Feature.fromJson(e)).toList() ?? const [];
  }

  Future<List<StatisticRecord>> queryStatistics(
      StatisticsQueryParameters statisticsQueryParameters) async {
    final result = await invokeMethod<List<dynamic>>(
      'serviceFeatureTable#queryStatistics',
      arguments: statisticsQueryParameters.toJson(),
    );
    return result?.map((e) => StatisticRecord.fromJson(e)).toList() ?? const [];
  }

  Future<int> queryFeatureCount(QueryParameters queryParameters) async {
    final result = await invokeMethod<int>(
      'serviceFeatureTable#queryFeatureCount',
      arguments: queryParameters.toJson(),
    );
    return result ?? 0;
  }
}
