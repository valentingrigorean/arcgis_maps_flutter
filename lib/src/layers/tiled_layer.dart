part of '../../arcgis_maps_flutter.dart';

class TiledLayer extends BaseTileLayer {
  final TileCache? _tileCache;

  const TiledLayer.fromUrl(
    String url, {
    required super.layerId,
    super.isVisible,
    super.opacity,
  })  : _tileCache = null,
        super.fromUrl(
          url: url,
          type: 'TiledLayer',
        );

  const TiledLayer.fromTileCache({
    required TileCache tileCache,
    required super.layerId,
    super.isVisible,
    super.opacity,
  })  : _tileCache = tileCache,
        super(
          type: 'TiledLayer',
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
        isVisible: isVisibleParam ?? isVisible,
        opacity: opacityParam ?? opacity,
      );
    }

    return TiledLayer.fromUrl(
      url!,
      layerId: layerId,
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
