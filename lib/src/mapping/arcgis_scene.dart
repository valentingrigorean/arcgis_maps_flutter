part of arcgis_maps_flutter;

@immutable
class ArcGISScene {
  final Basemap? _basemap;
  final String? _json;

  const ArcGISScene._(this._basemap, this._json);

  factory ArcGISScene.fromBasemap(Basemap basemap) =>
      ArcGISScene._(basemap, null);

  factory ArcGISScene.fromJson(String json) => ArcGISScene._(null, json);

  Object toJson() {
    final Map<String, Object> json = <String, Object>{};

    if (_basemap != null) {
      json['basemap'] = _basemap!.toJson();
    } else {
      json['json'] = _json!;
    }
    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArcGISScene &&
          runtimeType == other.runtimeType &&
          _basemap == other._basemap &&
          _json == other._json;

  @override
  int get hashCode => _basemap.hashCode ^ _json.hashCode;
}