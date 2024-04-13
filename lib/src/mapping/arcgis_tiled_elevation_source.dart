part of '../../arcgis_maps_flutter.dart';

@immutable
class ArcGISTiledElevationSource implements ElevationSource {
  const ArcGISTiledElevationSource({
    required this.elevationSourceId,
    required this.url,
  });

  final String elevationSourceId;

  final String url;

  @override
  clone() {
    return ArcGISTiledElevationSource(
        elevationSourceId: elevationSourceId, url: url);
  }

  @override
  String get mapsId => elevationSourceId;

  @override
  Object toJson() {
    final Map<String, Object> json = <String, Object>{};

    json.addIfNonNull('elevationSourceId', elevationSourceId);
    json.addIfNonNull('elevationType', 'ArcGISTiledElevationSource');
    json.addIfNonNull('url', url);

    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArcGISTiledElevationSource &&
          runtimeType == other.runtimeType &&
          elevationSourceId == other.elevationSourceId &&
          url == other.url;

  @override
  int get hashCode => elevationSourceId.hashCode;
}
