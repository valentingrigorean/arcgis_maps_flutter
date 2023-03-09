part of arcgis_maps_flutter;

enum SortOrder {
  ascending("ASCENDING"),
  descending("DESCENDING");

  final String alias;

  const SortOrder(this.alias);
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
  SpatialRelationship? spatialRelationship;

  String get type => "QueryParameters";

  final bool isReturnGeometry;
  final Geometry? geometry;
  int _maxFeatures = 0;

  int get maxFeatures => _maxFeatures;
  final int resultOffset;

  set maxFeatures(int value) {
    if (value > 0) {
      _maxFeatures = value;
    } else {
      throw ArgumentError("Max features cannot be less than 0.");
    }
  }

  final String? whereClause;

  QueryParameters(
      {this.isReturnGeometry = false,
      this.geometry,
      this.resultOffset = 0,
      this.spatialRelationship,
      this.whereClause,
      int maxFeatures = 0})
      : assert(maxFeatures >= 0),
        _maxFeatures = maxFeatures;

  QueryParameters.fromJson(Map<dynamic, dynamic> json)
      : this(
            isReturnGeometry: json["isReturnGeometry"],
            geometry: Geometry.fromJson(json["geometry"]),
            resultOffset: json["resultOffset"],
            maxFeatures: json["maxFeatures"],
            spatialRelationship:
                SpatialRelationship.fromValue(json["spatialRelationship"]),
            whereClause: json["whereClause"]);

  Map<String, dynamic> toJson() {
    return {
      "isReturnGeometry": isReturnGeometry,
      "geometry": geometry?.toJson(),
      "resultOffset": resultOffset,
      "maxFeatures": maxFeatures,
      "spatialRelationship": spatialRelationship?.value,
      "whereClause": whereClause
    };
  }
}
