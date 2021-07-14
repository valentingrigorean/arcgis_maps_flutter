part of arcgis_maps_flutter;

@immutable
class LegendInfoResult {
  const LegendInfoResult({
    required this.layer,
    required this.results,
  });

  final Layer layer;
  final List<LegendInfo> results;
}
