part of '../../arcgis_maps_flutter.dart';

@immutable
class LegendInfoResult {
  const LegendInfoResult({
    required this.layerName,
    required this.results,
  });

  final String layerName;
  final List<LegendInfo> results;

  static LegendInfoResult? fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) return null;
    var results = json['results'] as List<dynamic>;
    return LegendInfoResult(
      layerName: json['layerName'] as String,
      results: results.map((e) => LegendInfo.fromJson(e)!).toList(),
    );
  }
}
