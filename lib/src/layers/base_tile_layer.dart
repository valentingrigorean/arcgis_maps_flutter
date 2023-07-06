import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';

abstract class BaseTileLayer extends Layer {
  const BaseTileLayer({
    required LayerId layerId,
    required this.type,
    bool isVisible = true,
    double opacity = 1,
  })  : url = null,
        portalItem = null,
        super(
          layerId: layerId,
          opacity: opacity,
          isVisible: isVisible,
        );

  const BaseTileLayer.fromUrl({
    required LayerId layerId,
    required String url,
    required this.type,
    bool isVisible = true,
    double opacity = 1,
  })  : portalItem = null,
        // ignore: prefer_initializing_formals
        url = url,
        super(
          layerId: layerId,
          isVisible: isVisible,
          opacity: opacity,
        );

  const BaseTileLayer.fromPortalItem({
    required LayerId layerId,
    required PortalItem portalItem,
    required this.type,
    bool isVisible = true,
    double opacity = 1,
  })  : url = null,
        // ignore: prefer_initializing_formals
        portalItem = portalItem,
        super(
          layerId: layerId,
          isVisible: isVisible,
          opacity: opacity,
        );

  final String? url;

  final String type;

  final PortalItem? portalItem;

  @override
  Map<String, Object> toJson() {
    final Map<String, Object> json = super.toJson();
    json["layerType"] = type;
    if (url != null) {
      json["url"] = url!;
    }
    json["layerId"] = layerId.value;

    if (portalItem != null) {
      json['portalItem'] = portalItem!.toJson();
    }
    return json;
  }

  @override
  List<Object?> get props => super.props
    ..addAll([
      type,
      url,
      portalItem,
    ]);
}
