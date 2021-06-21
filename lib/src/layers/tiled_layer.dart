part of arcgis_maps_flutter;

class TiledLayer extends BaseTileLayer {
  TiledLayer._({
    required LayerId layerId,
    required String url,
    Credential? credential,
    bool isVisible = true,
    double opacity = 1,
  }) : super(
          isVisible: isVisible,
          opacity: opacity,
          layerId: layerId,
          url: url,
          type: "TiledLayer",
          credential: credential,
        );

  factory TiledLayer.fromUrl(
    String url, {
    LayerId? layerId,
    Credential? credential,
    bool isVisible = true,
    double opacity = 1,
  }) =>
      TiledLayer._(
        layerId: layerId ?? LayerId(url),
        url: url,
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
    return TiledLayer._(
      layerId: layerId,
      url: url,
      credential: credential,
      isVisible: isVisibleParam ?? isVisible,
      opacity: opacityParam ?? opacity,
    );
  }
}
