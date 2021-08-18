part of arcgis_maps_flutter;


@immutable
class MapImageLayer extends BaseTileLayer {
  const MapImageLayer._({
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
    type: 'MapImageLayer',
    credential: credential,
  );

  factory MapImageLayer.fromUrl(String url, {
    LayerId? layerId,
    Credential? credential,
    bool isVisible = true,
    double opacity = 1,
  }) =>
      MapImageLayer._(
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

  MapImageLayer copyWith({
    bool? isVisibleParam,
    double? opacityParam,
  }) {
    return MapImageLayer._(
      layerId: layerId,
      url: url,
      credential: credential,
      isVisible: isVisibleParam ?? isVisible,
      opacity: opacityParam ?? opacity,
    );
  }
}
