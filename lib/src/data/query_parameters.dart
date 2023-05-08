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
  final SpatialRelationship? spatialRelationship;
  final bool isReturnGeometry;
  final Geometry? geometry;
  final int maxFeatures;
  final int resultOffset;

  final String whereClause;

  const QueryParameters({
    this.isReturnGeometry = false,
    this.geometry,
    this.resultOffset = 0,
    this.spatialRelationship,
    this.whereClause = '',
    this.maxFeatures = 0,
  }) : assert(maxFeatures >= 0);

  QueryParameters.fromJson(Map<dynamic, dynamic> json)
      : this(
          isReturnGeometry: json["isReturnGeometry"],
          geometry: Geometry.fromJson(json["geometry"]),
          resultOffset: json["resultOffset"],
          maxFeatures: json["maxFeatures"],
          spatialRelationship:
              SpatialRelationship.fromValue(json["spatialRelationship"]),
          whereClause: json["whereClause"],
        );

  Map<String, dynamic> toJson() {
    return {
      "isReturnGeometry": isReturnGeometry,
      if (geometry != null) "geometry": geometry?.toJson(),
      "resultOffset": resultOffset,
      "maxFeatures": maxFeatures,
      if (spatialRelationship != null)
        "spatialRelationship": spatialRelationship?.value,
      "whereClause": whereClause
    };
  }
}
