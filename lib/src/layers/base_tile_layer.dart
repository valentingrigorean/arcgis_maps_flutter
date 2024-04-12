import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';

abstract class BaseTileLayer extends Layer {
  const BaseTileLayer({
    required super.layerId,
    required this.type,
    super.isVisible = true,
    super.opacity = 1,
  })  : url = null,
        portalItem = null;

  const BaseTileLayer.fromUrl({
    required super.layerId,
    required String this.url,
    required this.type,
    super.isVisible = true,
    super.opacity = 1,
  })  : portalItem = null;

  const BaseTileLayer.fromPortalItem({
    required super.layerId,
    required PortalItem this.portalItem,
    required this.type,
    super.isVisible = true,
    super.opacity = 1,
  })  : url = null;

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
