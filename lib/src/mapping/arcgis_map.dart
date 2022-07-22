part of arcgis_maps_flutter;

enum BasemapType {
  imagery,
  imageryWithLabels,
  streets,
  topographic,
  terrainWithLabels,
  lightGrayCanvas,
  nationalGeographic,
  oceans,
  openStreetMap,
  imageryWithLabelsVector,
  streetsVector,
  topographicVector,
  terrainWithLabelsVector,
  lightGrayCanvasVector,
  navigationVector,
  streetsNightVector,
  streetsWithReliefVector,
  darkGrayCanvasVector
}

int _arcgisMapHandlerId = 0;

class ArcGISMap {
  final BasemapTypeOptions? _basemapTypeOptions;
  final String? _baseMap;
  final Layer? _baseLayer;
  final PortalItem? _portalItem;
  final String? _offlinePath;
  final int _offlineMapIndex;
  final int _id;

  bool _isDisposed = false;

  ArcGISMap._({
    BasemapTypeOptions? basemapTypeOptions,
    String? baseMap,
    Layer? baseLayer,
    PortalItem? portalItem,
    String? offlinePath,
    int offlineMapIndex = 0,
  })  : _basemapTypeOptions = basemapTypeOptions,
        _baseMap = baseMap,
        _baseLayer = baseLayer,
        _portalItem = portalItem,
        _offlinePath = offlinePath,
        _offlineMapIndex = offlineMapIndex,
        _id = _arcgisMapHandlerId++;

  factory ArcGISMap.fromPortalItem(PortalItem portalItem) =>
      ArcGISMap._(portalItem: portalItem);

  factory ArcGISMap.empty() => ArcGISMap._();

  factory ArcGISMap.fromBaseLayer(Layer layer) => ArcGISMap._(baseLayer: layer);

  factory ArcGISMap.fromBasemapType({
    required BasemapType basemapType,
    required double latitude,
    required double longitude,
    required int levelOfDetail,
  }) =>
      ArcGISMap._(
        basemapTypeOptions: BasemapTypeOptions(
          basemapType: basemapType,
          latitude: latitude,
          longitude: longitude,
          levelOfDetail: levelOfDetail,
        ),
      );

  /// Instantiates a new basemap based on ArcGIS Online [World Street](http://www.arcgis.com/home/item.html?id=3b93337983e9436f8db950e38a8629af ) basemap.
  factory ArcGISMap.streets() => ArcGISMap._(baseMap: 'streets');

  /// Instantiates a new basemap based on ArcGIS Online [World Topographic](http://www.arcgis.com/home/item.html?id=30e5fe3149c34df1ba922e6f5bbf808f ) basemap.
  factory ArcGISMap.topographic() => ArcGISMap._(baseMap: 'topographic');

  /// Instantiates a new basemap based on ArcGIS Online [World Imagery](http://www.arcgis.com/home/item.html?id=10df2279f9684e4a9f6a7f08febac2a9 ) basemap.
  factory ArcGISMap.imagery() => ArcGISMap._(baseMap: 'imagery');

  /// Instantiates a new basemap based on ArcGIS Online [Dark Gray Canvas](http://www.arcgis.com/home/item.html?id=850db44b9eb845d3bd42b19e8aa7a024 ) basemap.
  factory ArcGISMap.darkGrayCanvasVector() =>
      ArcGISMap._(baseMap: 'darkGrayCanvasVector');

  /// Instantiates a new basemap based on ArcGIS Online [Imagery Hybrid](http://www.arcgis.com/home/item.html?id=28f49811a6974659988fd279de5ce39f ) basemap.
  factory ArcGISMap.imageryWithLabelsVector() =>
      ArcGISMap._(baseMap: 'imageryWithLabelsVector');

  /// Instantiates a new basemap based on ArcGIS Online [Light Gray Canvas](http://www.arcgis.com/home/item.html?id=0e02e6f86d02455091796eaae811d9b5 ) basemap.
  factory ArcGISMap.lightGrayCanvasVector() =>
      ArcGISMap._(baseMap: 'lightGrayCanvasVector');

  ///  Instantiates a new basemap based on ArcGIS Online [World Navigation Map](http://www.arcgis.com/home/item.html?id=dcbbba0edf094eaa81af19298b9c6247 ) basemap.
  factory ArcGISMap.navigationVector() =>
      ArcGISMap._(baseMap: 'navigationVector');

  /// Instantiates a new basemap based on OpenStreetMap basemap.
  factory ArcGISMap.openStreetMap() => ArcGISMap._(baseMap: 'openStreetMap');

  /// Instantiates a new basemap based on ArcGIS Online [World Street Map (Night)](http://www.arcgis.com/home/item.html?id=bf79e422e9454565ae0cbe9553cf6471 ) basemap.
  factory ArcGISMap.streetsNightVector() =>
      ArcGISMap._(baseMap: 'streetsNightVector');

  /// Instantiates a new basemap based on ArcGIS Online [World Street Map](http://www.arcgis.com/home/item.html?id=4e1133c28ac04cca97693cf336cd49ad ) basemap.
  factory ArcGISMap.streetsVector() => ArcGISMap._(baseMap: 'streetsVector');

  /// Instantiates a new basemap based on ArcGIS Online [Streets (with Relief)](http://www.arcgis.com/home/item.html?id=00f90f3f3c9141e4bea329679b257142 ) basemap.
  factory ArcGISMap.streetsWithReliefVector() =>
      ArcGISMap._(baseMap: 'streetsWithReliefVector');

  /// Instantiates a new basemap based on ArcGIS Online [Terrain with Labels](http://www.arcgis.com/home/item.html?id=a52ab98763904006aa382d90e906fdd5 ) basemap.
  factory ArcGISMap.terrainWithLabelsVector() =>
      ArcGISMap._(baseMap: 'terrainWithLabelsVector');

  /// Instantiates a new basemap based on ArcGIS Online [Topographic](http://www.arcgis.com/home/item.html?id=67372ff42cd145319639a99152b15bc3 ) basemap.
  factory ArcGISMap.topographicVector() =>
      ArcGISMap._(baseMap: 'topographicVector');

  /// Instantiates a new basemap based on ArcGIS Online [Light Gray Canvas](http://www.arcgis.com/home/item.html?id=8b3d38c0819547faa83f7b7aca80bd76 ) basemap.
  factory ArcGISMap.lightGrayCanvas() =>
      ArcGISMap._(baseMap: 'lightGrayCanvas');

  /// Instantiates a new basemap based on ArcGIS Online [Oceans](http://www.arcgis.com/home/item.html?id=6348e67824504fc9a62976434bf0d8d5 ) basemap.
  factory ArcGISMap.oceans() => ArcGISMap._(baseMap: 'oceans');

  /// Instantiates a new basemap based on ArcGIS Online [National Geographic World](http://www.arcgis.com/home/item.html?id=b9b1b422198944fbbd5250b3241691b6 ) basemap.
  factory ArcGISMap.nationalGeographic() =>
      ArcGISMap._(baseMap: 'nationalGeographic');

  /// Instantiates a new basemap based on ArcGIS Online [Imagery with Labels](http://www.arcgis.com/home/item.html?id=716b600dbbac433faa4bec9220c76b3a ) basemap.
  factory ArcGISMap.imageryWithLabels() =>
      ArcGISMap._(baseMap: 'imageryWithLabels');

  /// Instantiates a new basemap based on ArcGIS Online [Terrain with Labels](http://www.arcgis.com/home/item.html?id=fe44cf9a739848939988addfeba473e4 ) basemap.
  factory ArcGISMap.terrainWithLabels() =>
      ArcGISMap._(baseMap: 'terrainWithLabels');

  factory ArcGISMap.offlineMap(String path, {int mapIndex = 0}) =>
      ArcGISMap._(offlinePath: path, offlineMapIndex: mapIndex);

  void dispose() {
    if (_isDisposed) {
      return;
    }
    _isDisposed = true;
  }

  Object toJson() {
    final Map<String, Object> json = <String, Object>{};
    if (_basemapTypeOptions != null) {
      json['basemapTypeOptions'] = _basemapTypeOptions!.toJson();
    }
    if (_baseMap != null) {
      json['baseMap'] = _baseMap!;
    }
    if (_baseLayer != null) {
      json['baseLayer'] = _baseLayer!.toJson();
    }
    if (_portalItem != null) {
      json['portalItem'] = _portalItem!.toJson();
    }
    if (_offlinePath != null) {
      json['offlinePath'] = _offlinePath!;
      json['offlineMapIndex'] = _offlineMapIndex;
    }
    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArcGISMap &&
          runtimeType == other.runtimeType &&
          _basemapTypeOptions == other._basemapTypeOptions &&
          _baseMap == other._baseMap &&
          _baseLayer == other._baseLayer &&
          _portalItem == other._portalItem;

  @override
  int get hashCode =>
      _basemapTypeOptions.hashCode ^
      _baseMap.hashCode ^
      _baseLayer.hashCode ^
      _portalItem.hashCode;
}
