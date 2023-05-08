part of arcgis_maps_flutter;

@immutable
class Feature {
  const Feature._({
   required this.attributes,
    required this.featureTable,
   required this.geometry,
  });

  factory Feature.fromJson(Map<dynamic, dynamic> json) {
    return Feature._(
      attributes: json["attributes"] as Map<String, Object?>,
      featureTable: FeatureTable.fromJson(json["featureTable"]),
      geometry: Geometry.fromJson(json["geometry"]),
    );
  }

  final Map<String, Object?> attributes;

  final FeatureTable featureTable;

  final Geometry? geometry;
}
