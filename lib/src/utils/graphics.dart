import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/utils/maps_object.dart';

Map<GraphicId, Graphic> keyByGraphicId(Iterable<Graphic> graphics) {
  return keyByMapsObjectId<Graphic>(graphics).cast<GraphicId, Graphic>();
}

Object serializeGraphicSet(Set<Graphic> graphics) {
  return serializeMapsObjectSet(graphics);
}
