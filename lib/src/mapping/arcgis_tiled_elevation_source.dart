part of arcgis_maps_flutter;

@immutable
class ArcGISTiledElevationSource implements ElevationSource {
  const ArcGISTiledElevationSource(
      {required this.elevationSourceId, required this.url});

  final ElevationSourceId elevationSourceId;

  final String url;

  @override
  clone() {
    return ArcGISTiledElevationSource(
        elevationSourceId: elevationSourceId, url: url);
  }

  @override
  MapsObjectId get mapsId => elevationSourceId;

  @override
  Object toJson() {
    final Map<String, Object> json = <String, Object>{};

    void addIfPresent(String fieldName, Object? value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('elevationSourceId', elevationSourceId.value);
    addIfPresent('elevationType', 'ArcGISTiledElevationSource');
    addIfPresent('url', url);

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
