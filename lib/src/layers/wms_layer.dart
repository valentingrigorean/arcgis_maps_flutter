part of arcgis_maps_flutter;

class WmsLayer extends BaseTileLayer {
  const WmsLayer._({
    required LayerId layerId,
    required String url,
    required this.layersName,
    Credential? credential,
    bool isVisible = true,
    double opacity = 1,
  }) : super(
          isVisible: isVisible,
          opacity: opacity,
          layerId: layerId,
          url: url,
          type: 'WmsLayer',
          credential: credential,
        );

  final List<String> layersName;

  factory WmsLayer.fromUrl(
    String url, {
    required List<String> layersName,
    LayerId? layerId,
    Credential? credential,
    bool isVisible = true,
    double opacity = 1,
  }) =>
      WmsLayer._(
        layerId: layerId ?? LayerId(url),
        url: url,
        layersName: layersName,
        credential: credential,
        isVisible: isVisible,
        opacity: opacity,
      );

  @override
  Map<String, Object> toJson() {
    final Map<String, Object> json = super.toJson();
    json['layersName'] = layersName;
    return json;
  }

  @override
  clone() {
    return copyWith();
  }

  WmsLayer copyWith({
    bool? isVisibleParam,
    double? opacityParam,
  }) {
    return WmsLayer._(
      layerId: layerId,
      url: url,
      credential: credential,
      layersName: layersName,
      isVisible: isVisibleParam ?? isVisible,
      opacity: opacityParam ?? opacity,
    );
  }
}
