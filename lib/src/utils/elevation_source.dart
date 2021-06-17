import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/utils/maps_object.dart';

Object serializeElevationSourceSet(Set<ElevationSource> layers) {
  return serializeMapsObjectSet(layers);
}
