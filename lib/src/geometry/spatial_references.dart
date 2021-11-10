part of arcgis_maps_flutter;

@immutable
class SpatialReference {
  static const SpatialReference _wgs84 = SpatialReference._(wkId: 4326);
  static const SpatialReference _webMercator = SpatialReference._(wkId: 3857);

  const SpatialReference._({this.wkId, this.wkText});

  ///  Initializes a spatial reference with the given well-known ID (WKID).
  factory SpatialReference.fromWkId(int wkId) => SpatialReference._(wkId: wkId);

  // ///  Initializes a spatial reference with the given well-known text (WKT).
  // factory SpatialReference.fromWkText(String wkText) =>
  //     SpatialReference._(wkText: wkText);

  factory SpatialReference.wgs84() => _wgs84;

  factory SpatialReference.webMercator() => _webMercator;

  final int? wkId;

  final String? wkText;

  static SpatialReference? fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) {
      return null;
    }
    final int wkId = json['wkid'] ?? json['wkId'];
    switch (wkId) {
      case 4326:
        return _wgs84;
      case 3857:
        return _webMercator;
    }
    return SpatialReference._(wkId: wkId);
  }

  Object toJson() {
    final Map<String, Object> json = <String, Object>{};
    if (wkId != null) {
      json['wkId'] = wkId!;
    }

    if (wkText != null) {
      json['wkText'] = wkText!;
    }
    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpatialReference &&
          runtimeType == other.runtimeType &&
          wkId == other.wkId;

  @override
  int get hashCode => wkId.hashCode;

  @override
  String toString() {
    return 'SpatialReference{wkId: $wkId, wkText: $wkText}';
  }
}
