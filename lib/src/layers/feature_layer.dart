part of arcgis_maps_flutter;

@immutable
class FeatureLayer extends BaseTileLayer {
  const FeatureLayer._({
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
          type: 'FeatureLayer',
          credential: credential,
        );

  factory FeatureLayer.fromUrl(
    String url, {
    LayerId? layerId,
    Credential? credential,
    bool isVisible = true,
    double opacity = 1,
  }) =>
      FeatureLayer._(
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

  FeatureLayer copyWith({
    bool? isVisibleParam,
    double? opacityParam,
  }) {
    return FeatureLayer._(
      layerId: layerId,
      url: url,
      credential: credential,
      isVisible: isVisibleParam ?? isVisible,
      opacity: opacityParam ?? opacity,
    );
  }
}
