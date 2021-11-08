part of arcgis_maps_flutter;

@immutable
class AGSEnvelope extends Geometry {
  const AGSEnvelope({
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

  static AGSEnvelope? fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) return null;
    final bbox = json['bbox'] as List<dynamic>;
    return AGSEnvelope(
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
}
