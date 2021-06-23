part of arcgis_maps_flutter;

@immutable
class VectorTileLayer extends BaseTileLayer {
  const VectorTileLayer._({
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
          type: 'VectorTileLayer',
          credential: credential,
        );

  factory VectorTileLayer.fromUrl(
    String url, {
    LayerId? layerId,
    Credential? credential,
    bool isVisible = true,
    double opacity = 1,
  }) =>
      VectorTileLayer._(
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

  VectorTileLayer copyWith({
    bool? isVisibleParam,
    double? opacityParam,
  }) {
    return VectorTileLayer._(
      layerId: layerId,
      url: url,
      credential: credential,
      isVisible: isVisibleParam ?? isVisible,
      opacity: opacityParam ?? opacity,
    );
  }
}
