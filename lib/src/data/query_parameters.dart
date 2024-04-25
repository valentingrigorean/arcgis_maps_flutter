part of arcgis_maps_flutter;

enum SortOrder {
  ascending(0),
  descending(1);

  final int value;

  const SortOrder(this.value);
}

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
  const QueryParameters({
    this.returnGeometry = true,
    this.geometry,
    this.resultOffset,
    this.spatialRelationship,
    this.whereClause = '',
    this.maxFeatures,
  });

  final SpatialRelationship? spatialRelationship;
  final bool returnGeometry;
  final Geometry? geometry;
  final int? maxFeatures;
  final int? resultOffset;

  final String whereClause;

  factory QueryParameters.fromJson(Map<dynamic, dynamic> json) {
    return QueryParameters(
      returnGeometry: json["returnGeometry"] ?? true,
      geometry: Geometry.fromJson(json["geometry"]),
      resultOffset: json["resultOffset"],
      maxFeatures: json["maxFeatures"],
      spatialRelationship:
          SpatialRelationship.fromValue(json["spatialRelationship"]),
      whereClause: json["whereClause"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "returnGeometry": returnGeometry,
      if (geometry != null) "geometry": geometry?.toJson(),
      if (resultOffset != null) "resultOffset": resultOffset,
      if (maxFeatures != null) "maxFeatures": maxFeatures,
      if (spatialRelationship != null)
        "spatialRelationship": spatialRelationship?.value,
      "whereClause": whereClause
    };
  }
}
