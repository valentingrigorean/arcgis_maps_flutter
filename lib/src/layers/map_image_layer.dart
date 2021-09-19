part of arcgis_maps_flutter;

@immutable
class MapImageLayer extends BaseTileLayer {
  MapImageLayer.fromUrl(
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
          type: 'MapImageLayer',
          credential: credential,
        );

  @override
  clone() {
    return copyWith();
  }

  MapImageLayer copyWith({
    bool? isVisibleParam,
    double? opacityParam,
  }) {
    return MapImageLayer.fromUrl(
      url!,
      layerId: layerId,
      credential: credential,
      isVisible: isVisibleParam ?? isVisible,
      opacity: opacityParam ?? opacity,
    );
  }
}
