part of '../../arcgis_maps_flutter.dart';

@immutable
class MapImageLayer extends BaseTileLayer {
  MapImageLayer.fromUrl(
    String url, {
    LayerId? layerId,
    super.isVisible,
    super.opacity,
  }) : super.fromUrl(
          layerId: layerId ?? LayerId(url),
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
