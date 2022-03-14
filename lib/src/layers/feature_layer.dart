part of arcgis_maps_flutter;

@immutable
class FeatureLayer extends BaseTileLayer {
  FeatureLayer.fromUrl(
    String url, {
    LayerId? layerId,
    Credential? credential,
    bool isVisible = true,
    double opacity = 1,
  })  : portalItemLayerId = -1,
        super.fromUrl(
          isVisible: isVisible,
          opacity: opacity,
          layerId: layerId ?? LayerId(url),
          url: url,
          type: 'FeatureLayer',
          credential: credential,
        );

  const FeatureLayer.fromPortalItem({
    required LayerId layerId,
    required PortalItem portalItem,
    required this.portalItemLayerId,
    bool isVisible = true,
    double opacity = 1,
  }) : super.fromPortalItem(
          isVisible: isVisible,
          opacity: opacity,
          layerId: layerId,
          portalItem: portalItem,
          type: 'FeatureLayer',
        );

  final int portalItemLayerId;

  @override
  clone() {
    return copyWith();
  }

  @override
  Map<String, Object> toJson() {
    var json = super.toJson();
    if (portalItem != null) {
      json['portalItemLayerId'] = portalItemLayerId;
    }
    return json;
  }

  FeatureLayer copyWith({
    bool? isVisibleParam,
    double? opacityParam,
  }) {
    if (url != null) {
      return FeatureLayer.fromUrl(
        url!,
        layerId: layerId,
        credential: credential,
        isVisible: isVisibleParam ?? isVisible,
        opacity: opacityParam ?? opacity,
      );
    }

    return FeatureLayer.fromPortalItem(
      layerId: layerId,
      portalItem: portalItem!,
      isVisible: isVisibleParam ?? isVisible,
      opacity: opacityParam ?? opacity,
      portalItemLayerId: portalItemLayerId,
    );
  }
}
