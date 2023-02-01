part of arcgis_maps_flutter;

enum SpatialRelationship {
  unknown(-1),
  relate(0),
  equals(1),
  disjoint(2),
  intersects(3),
  touches(4),
  crosses(5),
  within(6),
  contains(7),
  overlaps(8),
  envelopeIntersects(9),
  indexIntersects(10);

  const SpatialRelationship(this.value);

  factory SpatialRelationship.fromValue(int value) {
    return SpatialRelationship.values.firstWhere(
          (e) => e.value == value,
      orElse: () => SpatialRelationship.unknown,
    );
  }

  final int value;
}

class QueryParameters {

  QueryParameters({
    this.spatialRelationship,
  });

  SpatialRelationship? spatialRelationship;

  @override
  String get type => "QueryParameters";

  Object toJson() {
    final json = <String, dynamic>{};
    json['spatialRelationship'] = spatialRelationship?.value;
    return json;
  }
}
