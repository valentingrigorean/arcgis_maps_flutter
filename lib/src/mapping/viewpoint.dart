part of arcgis_maps_flutter;

@immutable
class Viewpoint {
  const Viewpoint._({
    this.scale,
    required this.targetGeometry,
    required this.viewpointType,
    this.rotation,
  });

  factory Viewpoint.fromPoint({
    required AGSPoint point,
    required double scale,
  }) =>
      Viewpoint._(
        targetGeometry: point,
        scale: scale,
        viewpointType: ViewpointType.centerAndScale,
      );

  factory Viewpoint.fromLatLng({
    required double latitude,
    required double longitude,
    required double scale,
  }) =>
      Viewpoint._(
        scale: scale,
        targetGeometry:
            AGSPoint.fromLatLng(latitude: latitude, longitude: longitude),
        viewpointType: ViewpointType.centerAndScale,
      );

  final double? scale;

  /// The geometry represented by this viewpoint.
  /// If [viewpointType] is [ViewpointType.centerAndScale],
  /// this contains a point geometry.
  /// If[viewpointType] is [ViewpointType.boundingGeometry],
  /// this contains an envelope geometry.
  final Geometry targetGeometry;
  final ViewpointType viewpointType;

  final double? rotation;

  static Viewpoint? fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) {
      return null;
    }

    final targetGeometry = Geometry.fromJson(json['targetGeometry']);
    if (targetGeometry == null) {
      return null;
    }
    return Viewpoint._(
      targetGeometry: targetGeometry,
      viewpointType: targetGeometry is Envelope
          ? ViewpointType.boundingGeometry
          : ViewpointType.centerAndScale,
      scale: json['scale']?.toDouble(),
      rotation: json['rotation']?.toDouble() ?? 0,
    );
  }

  Object toJson() {
    final Map<String, Object> json = <String, Object>{};

    void addIfPresent(String fieldName, Object? value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('scale', scale);
    addIfPresent('targetGeometry', targetGeometry.toJson());
    addIfPresent('rotation', rotation);
    return json;
  }

  @override
  String toString() {
    return 'Viewpoint{scale: $scale, targetGeometry: $targetGeometry, viewpointType: $viewpointType, rotation: $rotation}';
  }
}
