part of arcgis_maps_flutter;

@immutable
class ArcGISScene {
  final Basemap? _basemap;
  final String? _json;

  ArcGISScene._(this._basemap, this._json);

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
  Basemap._(this.basemap);

  final String basemap;

  factory Basemap.createImagery() => Basemap._("createImagery");

  factory Basemap.createImageryWithLabels() =>
      Basemap._("createImageryWithLabels");

  factory Basemap.createImageryWithLabelsVector() =>
      Basemap._("createImageryWithLabelsVector");

  factory Basemap.createLightGrayCanvas() => Basemap._("createLightGrayCanvas");

  factory Basemap.createLightGrayCanvasVector() =>
      Basemap._("createLightGrayCanvasVector");

  factory Basemap.createDarkGrayCanvasVector() =>
      Basemap._("createDarkGrayCanvasVector");

  factory Basemap.createNationalGeographic() =>
      Basemap._("createNationalGeographic");

  factory Basemap.createNavigationVector() =>
      Basemap._("createNavigationVector");

  factory Basemap.createOceans() => Basemap._("createOceans");

  factory Basemap.createOpenStreetMap() => Basemap._("createOpenStreetMap");

  factory Basemap.createStreets() => Basemap._("createStreets");

  factory Basemap.createStreetsNightVector() =>
      Basemap._("createStreetsNightVector");

  factory Basemap.createStreetsWithReliefVector() =>
      Basemap._("createStreetsWithReliefVector");

  factory Basemap.createTerrainWithLabels() =>
      Basemap._("createTerrainWithLabels");

  factory Basemap.createTerrainWithLabelsVector() =>
      Basemap._("createTerrainWithLabelsVector");

  factory Basemap.createTopographic() => Basemap._("createTopographic");

  factory Basemap.createTopographicVector() =>
      Basemap._("createTopographicVector");

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
