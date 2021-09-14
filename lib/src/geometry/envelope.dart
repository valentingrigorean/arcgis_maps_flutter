part of arcgis_maps_flutter;

class Envelope implements Geometry {
  const Envelope({
    required this.xMin,
    required this.yMin,
    required this.xMax,
    required this.yMax,
    this.spatialReference,
  });

  final double xMin;
  final double xMax;

  final double yMin;
  final double yMax;

  final SpatialReference? spatialReference;

  static Envelope? fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) return null;
    final bbox = json['bbox'] as List<dynamic>;
    return Envelope(
      xMin: bbox[0].toDouble(),
      yMin: bbox[1].toDouble(),
      xMax: bbox[2].toDouble(),
      yMax: bbox[3].toDouble(),
      spatialReference: SpatialReference.fromJson(json['spatialReference']),
    );
  }

  @override
  Object toJson() {
    final Map<String, Object> json = <String, Object>{};

    json['bbox'] = [xMin, yMin, xMax, yMax];

    if (spatialReference != null) {
      json['spatialReference'] = spatialReference!.toJson();
    }

    return json;
  }

  @override
  String toString() {
    return 'Envelope{xMin: $xMin, xMax: $xMax, yMin: $yMin, yMax: $yMax, spatialReference: $spatialReference}';
  }
}
