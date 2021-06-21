part of arcgis_maps_flutter;

class ArcGISMapImageLayer extends BaseTileLayer {
  const ArcGISMapImageLayer._({
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
          type: "ArcGISMapImageLayer",
          credential: credential,
        );

  factory ArcGISMapImageLayer.fromUrl(
    String url, {
    LayerId? layerId,
    Credential? credential,
    bool isVisible = true,
    double opacity = 1,
  }) =>
      ArcGISMapImageLayer._(
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

  ArcGISMapImageLayer copyWith({
    bool? isVisibleParam,
    double? opacityParam,
  }) {
    return ArcGISMapImageLayer._(
      layerId: layerId,
      url: url,
      credential: credential,
      isVisible: isVisibleParam ?? isVisible,
      opacity: opacityParam ?? opacity,
    );
  }
}
