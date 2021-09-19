part of arcgis_maps_flutter;

class TiledLayer extends BaseTileLayer {
  TiledLayer.fromUrl(
    String url, {
    LayerId? layerId,
    Credential? credential,
    bool isVisible = true,
    double opacity = 1,
  }) : super.fromUrl(
          isVisible: isVisible,
          opacity: opacity,
          layerId: layerId ?? LayerId(url),
          url: url,
          type: 'TiledLayer',
          credential: credential,
        );

  @override
  clone() {
    return copyWith();
  }

  TiledLayer copyWith({
    bool? isVisibleParam,
    double? opacityParam,
  }) {
    return TiledLayer.fromUrl(
      url!,
      layerId: layerId,
      credential: credential,
      isVisible: isVisibleParam ?? isVisible,
      opacity: opacityParam ?? opacity,
    );
  }
}
