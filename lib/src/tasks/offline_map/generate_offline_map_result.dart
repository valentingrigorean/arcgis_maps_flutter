part of arcgis_maps_flutter;

@immutable
class GenerateOfflineMapResult {
  const GenerateOfflineMapResult._({
    required this.offlineMap,
    required this.hasErrors,
    required this.layerErrors,
    required this.mobileMapPackage,
  });

  final ArcGISMap offlineMap;
  final bool hasErrors;

  final Map<Layer, Object?> layerErrors;

  //TODO(vali): implement AGSFeatureTable errors

  final MobileMapPackage mobileMapPackage;
}
