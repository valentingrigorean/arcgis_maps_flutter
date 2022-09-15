part of arcgis_maps_flutter;

class TiledLayer extends BaseTileLayer {
  final TileCache? _tileCache;

  TiledLayer.fromUrl(
    String url, {
    LayerId? layerId,
    Credential? credential,
    bool isVisible = true,
    double opacity = 1,
  })  : _tileCache = null,
        super.fromUrl(
          isVisible: isVisible,
          opacity: opacity,
          layerId: layerId ?? LayerId(url),
          url: url,
          type: 'TiledLayer',
          credential: credential,
        );

  TiledLayer.fromTileCache({
    required TileCache tileCache,
    LayerId? layerId,
    Credential? credential,
    bool isVisible = true,
    double opacity = 1,
  })  : _tileCache = tileCache,
        super(
          layerId: layerId ?? LayerId(tileCache.path),
          type: 'TiledLayer',
          credential: credential,
          isVisible: isVisible,
          opacity: opacity,
        );

  @override
  clone() {
    return copyWith();
  }

  TiledLayer copyWith({
    bool? isVisibleParam,
    double? opacityParam,
  }) {
    if (_tileCache != null) {
      return TiledLayer.fromTileCache(
        tileCache: _tileCache!,
        layerId: layerId,
        credential: credential,
        isVisible: isVisibleParam ?? isVisible,
        opacity: opacityParam ?? opacity,
      );
    }

    return TiledLayer.fromUrl(
      url!,
      layerId: layerId,
      credential: credential,
      isVisible: isVisibleParam ?? isVisible,
      opacity: opacityParam ?? opacity,
    );
  }

  @override
  Map<String, Object> toJson() {
    final Map<String, Object> json = super.toJson();
    if (_tileCache != null) {
      json['tileCache'] = _tileCache!.toJson();
    }
    return json;
  }
}
