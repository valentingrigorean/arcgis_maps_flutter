part of '../../arcgis_maps_flutter.dart';

@immutable
class MapImageLayer extends BaseTileLayer {
  const MapImageLayer.fromUrl(
    String url, {
    required super.layerId,
    super.isVisible,
    super.opacity,
  }) : super.fromUrl(
          url: url,
          type: 'MapImageLayer',
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
      isVisible: isVisibleParam ?? isVisible,
      opacity: opacityParam ?? opacity,
    );
  }
}
