import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/maps_object_updates.dart';

class LayerUpdates extends MapsObjectUpdates<Layer> {
  LayerUpdates.from(Set<Layer> previous, Set<Layer> current, String objectName)
      : super.from(previous, current, objectName: objectName);

  Set<Layer> get layersToAdd => objectsToAdd;

  Set<Layer> get layersToRemove => layersToRemove;
}
