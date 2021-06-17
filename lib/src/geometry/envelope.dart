part of arcgis_maps_flutter;

class Envelope implements Geometry {
  Envelope._({
    required this.xMin,
    required this.xMax,
    required this.yMin,
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
    return Envelope._(
      xMin: json['xmin'].toDouble(),
      xMax: json['xmax'].toDouble(),
      yMin: json['ymin'].toDouble(),
      yMax: json['ymax'].toDouble(),
      spatialReference: SpatialReference.fromJson(json['spatialReference']),
    );
  }

  @override
  Object toJson() {
    final Map<String, Object> json = <String, Object>{};

    // void addIfPresent(String fieldName, Object? value) {
    //   if (value != null) {
    //     json[fieldName] = value;
    //   }
    // }

    return json;
  }

  @override
  String toString() {
    return 'Envelope{xMin: $xMin, xMax: $xMax, yMin: $yMin, yMax: $yMax, spatialReference: $spatialReference}';
  }
}
