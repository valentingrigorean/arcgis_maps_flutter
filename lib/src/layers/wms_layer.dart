part of arcgis_maps_flutter;

class WmsLayer extends BaseTileLayer {
  WmsLayer.fromUrl(
    String url, {
    LayerId? layerId,
    required this.layersName,
    Credential? credential,
    bool isVisible = true,
    double opacity = 1,
  }) : super.fromUrl(
          isVisible: isVisible,
          opacity: opacity,
          layerId: layerId ?? LayerId(url),
          url: url,
          type: 'WmsLayer',
          credential: credential,
        );

  final List<String> layersName;

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
    return WmsLayer.fromUrl(
      url!,
      layerId: layerId,
      credential: credential,
      layersName: layersName,
      isVisible: isVisibleParam ?? isVisible,
      opacity: opacityParam ?? opacity,
    );
  }
}
