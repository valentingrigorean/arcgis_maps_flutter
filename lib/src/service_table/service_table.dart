part of arcgis_maps_flutter;

enum FeatureTableQueryFeatureFields {
  idsOnly("IDS_ONLY"),
  minimum("MINIMUM"),
  loadAll("LOAD_ALL");

  final String name;

  const FeatureTableQueryFeatureFields(this.name);
}

class ServiceTable {
  final MethodChannelServiceTableFlutter _serviceTableFlutter =
      MethodChannelServiceTableFlutter();

  Future<List<Feature>> queryFeatures(
      String url, QueryParameters queryParameters,
      {FeatureTableQueryFeatureFields queryFields =
          FeatureTableQueryFeatureFields.loadAll}) async {
    return _serviceTableFlutter.queryFeatures(url, queryParameters,
        queryFields: queryFields);
  }

  Future<StatisticResult> queryStatisticsAsync(
      String url, StatisticsQueryParameters statisticsQueryParameters) async {
    return _serviceTableFlutter.queryStatisticsAsync(url, statisticsQueryParameters);
  }

  Future<num> queryFeatureCount(
      String url, QueryParameters queryParameters) async {
    return _serviceTableFlutter.queryFeatureCount(url, queryParameters);
  }

}
