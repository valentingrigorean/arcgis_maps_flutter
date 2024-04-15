part of '../../arcgis_maps_flutter.dart';

@immutable
class VectorTileLayer extends BaseTileLayer {
  const VectorTileLayer.fromUrl(
    String url, {
    required super.layerId,
    super.isVisible,
    super.opacity,
  }) : super.fromUrl(
          url: url,
          type: 'VectorTileLayer',
        );

  @override
  clone() {
    return copyWith();
  }

  VectorTileLayer copyWith({
    bool? isVisibleParam,
    double? opacityParam,
  }) {
    return VectorTileLayer.fromUrl(
      url!,
      layerId: layerId,
      isVisible: isVisibleParam ?? isVisible,
      opacity: opacityParam ?? opacity,
    );
  }
}
