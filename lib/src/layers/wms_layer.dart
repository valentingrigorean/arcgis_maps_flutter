part of '../../arcgis_maps_flutter.dart';

class WmsLayer extends BaseTileLayer {
  const WmsLayer.fromUrl(
    String url, {
    required super.layerId,
    required this.layersName,
    super.isVisible,
    super.opacity,
  }) : super.fromUrl(
          url: url,
          type: 'WmsLayer',
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
      layersName: layersName,
      isVisible: isVisibleParam ?? isVisible,
      opacity: opacityParam ?? opacity,
    );
  }
}
