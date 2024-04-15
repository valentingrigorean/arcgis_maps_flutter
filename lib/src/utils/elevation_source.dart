import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';

Object serializeElevationSourceSet(Set<ElevationSource> layers) {
  return layers.map((ElevationSource layer) => layer.toJson()).toList();
}
