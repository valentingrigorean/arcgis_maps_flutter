part of arcgis_maps_flutter;

class QueryParameters {
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

  SpatialRelationshipInQueryParameters? spatialRelationship;

  QueryParameters.named(
      {this.isReturnGeometry = false,
      this.geometry,
      this.resultOffset = 0,
      this.spatialRelationship,
      this.whereClause,
      int maxFeatures = 0})
      : assert(maxFeatures >= 0),
        _maxFeatures = maxFeatures;

  QueryParameters.fromJson(Map<dynamic, dynamic> json)
      : this.named(
            isReturnGeometry: json["isReturnGeometry"],
            geometry: json["geometry"],
            resultOffset: json["resultOffset"],
            maxFeatures: json["maxFeatures"],
            spatialRelationship: json["spatialRelationship"],
            whereClause: json["whereClause"]);

  Map<String, dynamic> toJson() {
    return {
      "isReturnGeometry": isReturnGeometry,
      "geometry": geometry?.toJson(),
      "resultOffset": resultOffset,
      "maxFeatures": maxFeatures,
      "spatialRelationship": spatialRelationship?.name,
      "whereClause": whereClause
    };
  }
}

enum SpatialRelationshipInQueryParameters {
  unknown("UNKNOWN"),
  relate("RELATE"),
  equals("EQUALS"),
  disjoint("DISJOINT"),
  intersects("INTERSECTS"),
  touches("TOUCHES"),
  crosses("CROSSES"),
  within("WITHIN"),
  contains("CONTAINS"),
  overlaps("OVERLAPS"),
  envelopeIntersects("ENVELOPE_INTERSECTS"),
  indexIntersects("INDEX_INTERSECTS");

  final String name;

  const SpatialRelationshipInQueryParameters(this.name);
}
