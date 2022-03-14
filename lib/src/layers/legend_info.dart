part of arcgis_maps_flutter;

@immutable
class LegendInfo {
  const LegendInfo({
    required this.name,
    required this.symbolImage,
  });

  final String name;
  final Uint8List? symbolImage;

  static LegendInfo? fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) {
      return null;
    }

    return LegendInfo(
      name: json['name'],
      symbolImage: json['symbolImage'],
    );
  }
}
