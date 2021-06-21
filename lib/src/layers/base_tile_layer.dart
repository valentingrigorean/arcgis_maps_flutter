import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';

abstract class BaseTileLayer<T> extends Layer {
  const BaseTileLayer({
    required this.layerId,
    required this.url,
    required this.type,
    this.credential,
    bool isVisible = true,
    double opacity = 1,
  }) : super(isVisible: isVisible, opacity: opacity);

  final LayerId layerId;

  final String url;

  final String type;

  final Credential? credential;

  @override
  LayerId get mapsId => layerId;

  @override
  Map<String, Object> toJson() {
    final Map<String, Object> json = super.toJson();
    json["layerType"] = type;
    json["url"] = url;
    json["layerId"] = layerId.value;
    if (credential != null) {
      json["credential"] = credential!.toJson();
    }
    return json;
  }

  @override
  int get hashCode => layerId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseTileLayer &&
          runtimeType == other.runtimeType &&
          layerId == other.layerId &&
          url == other.url &&
          type == other.type &&
          credential == other.credential;

  @override
  String toString() {
    return '$type{url: $url}';
  }
}
