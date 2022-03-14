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

@immutable
class Basemap {
  const Basemap._(this.basemap);

  final String basemap;

  factory Basemap.createImagery() => const Basemap._("createImagery");

  factory Basemap.createImageryWithLabels() =>
      const Basemap._("createImageryWithLabels");

  factory Basemap.createImageryWithLabelsVector() =>
      const Basemap._("createImageryWithLabelsVector");

  factory Basemap.createLightGrayCanvas() => const Basemap._("createLightGrayCanvas");

  factory Basemap.createLightGrayCanvasVector() =>
      const Basemap._("createLightGrayCanvasVector");

  factory Basemap.createDarkGrayCanvasVector() =>
      const Basemap._("createDarkGrayCanvasVector");

  factory Basemap.createNationalGeographic() =>
      const Basemap._("createNationalGeographic");

  factory Basemap.createNavigationVector() =>
      const Basemap._("createNavigationVector");

  factory Basemap.createOceans() => const Basemap._("createOceans");

  factory Basemap.createOpenStreetMap() => const Basemap._("createOpenStreetMap");

  factory Basemap.createStreets() => const Basemap._("createStreets");

  factory Basemap.createStreetsNightVector() =>
      const Basemap._("createStreetsNightVector");

  factory Basemap.createStreetsWithReliefVector() =>
      const Basemap._("createStreetsWithReliefVector");

  factory Basemap.createTerrainWithLabels() =>
      const Basemap._("createTerrainWithLabels");

  factory Basemap.createTerrainWithLabelsVector() =>
      const Basemap._("createTerrainWithLabelsVector");

  factory Basemap.createTopographic() => const Basemap._("createTopographic");

  factory Basemap.createTopographicVector() =>
      const Basemap._("createTopographicVector");

  Object toJson() {
    return basemap;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Basemap &&
          runtimeType == other.runtimeType &&
          basemap == other.basemap;

  @override
  int get hashCode => basemap.hashCode;
}
