part of arcgis_maps_flutter;

enum FeatureTableQueryFeatureFields {
  idsOnly("IDS_ONLY"),
  minimum("MINIMUM"),
  loadAll("LOAD_ALL");

  final String name;

  const FeatureTableQueryFeatureFields(this.name);
}
