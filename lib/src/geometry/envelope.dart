part of arcgis_maps_flutter;

@immutable
class Envelope extends Geometry {
  const Envelope({
    required this.xMin,
    required this.yMin,
    required this.xMax,
    required this.yMax,
    SpatialReference? spatialReference,
  }) : super(
          spatialReference: spatialReference,
          geometryType: GeometryType.envelope,
        );

  final double xMin;
  final double xMax;

  final double yMin;
  final double yMax;

  Point get center => Point(
        x: (xMin + xMax) / 2,
        y: (yMin + yMax) / 2,
        spatialReference: spatialReference,
      );

  static Envelope? fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) return null;
    late List<dynamic>? bbox;
    if (json.containsKey('bbox')) {
      bbox = json['bbox'];
    } else if (json.containsKey('xmax')) {
      bbox = [json['xmin'], json['ymin'], json['xmax'], json['ymax']];
    }
    if (bbox == null) return null;
    return Envelope(
      xMin: bbox[0].toDouble(),
      yMin: bbox[1].toDouble(),
      xMax: bbox[2].toDouble(),
      yMax: bbox[3].toDouble(),
      spatialReference: SpatialReference.fromJson(json['spatialReference']),
    );
  }

  @override
  Map<String, Object> toJson() {
    final Map<String, Object> json = super.toJson();
    json['bbox'] = [xMin, yMin, xMax, yMax];
    return json;
  }

  @override
  String toString() {
    return 'Envelope{xMin: $xMin, xMax: $xMax, yMin: $yMin, yMax: $yMax, spatialReference: $spatialReference}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Envelope &&
          runtimeType == other.runtimeType &&
          xMin == other.xMin &&
          xMax == other.xMax &&
          yMin == other.yMin &&
          yMax == other.yMax;

  @override
  int get hashCode =>
      xMin.hashCode ^ xMax.hashCode ^ yMin.hashCode ^ yMax.hashCode;
}
