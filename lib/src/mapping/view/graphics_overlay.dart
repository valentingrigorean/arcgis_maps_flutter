part of '../../../arcgis_maps_flutter.dart';

class GraphicsOverlay extends Equatable {
  const GraphicsOverlay({
    required this.id,
    this.isVisible = true,
    this.minScale,
    this.maxScale,
    this.opacity = 1.0,
    this.renderer,
  });

  final String id;

  final bool isVisible;

  final double? minScale;

  final double? maxScale;

  final double opacity;

  final Renderer? renderer;

  Map<String, Object> toJson() {
    final Map<String, Object> json = <String, Object>{};
    json['id'] = id;
    json['isVisible'] = isVisible;
    json.addIfNonNull('minScale', minScale);
    json.addIfNonNull('maxScale', maxScale);
    json['opacity'] = opacity;
    json.addIfNonNull('renderer', renderer?.toJson());
    return json;
  }

  @override
  List<Object?> get props => <Object?>[
        id,
        isVisible,
        minScale,
        maxScale,
        opacity,
        renderer,
      ];
}
