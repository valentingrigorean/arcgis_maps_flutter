part of '../../arcgis_maps_flutter.dart';

@immutable
class FeatureLayer extends BaseTileLayer {
  FeatureLayer.fromUrl(
    String url, {
    LayerId? layerId,
    super.isVisible,
    super.opacity,
  })  : portalItemLayerId = -1,
        super.fromUrl(
          layerId: layerId ?? LayerId(url),
          url: url,
          type: 'FeatureLayer',
        );

  const FeatureLayer.fromPortalItem({
    required super.layerId,
    required super.portalItem,
    required this.portalItemLayerId,
    super.isVisible,
    super.opacity,
  }) : super.fromPortalItem(
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
