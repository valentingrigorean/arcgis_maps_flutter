import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/maps_object_updates.dart';

class LayerUpdates extends MapsObjectUpdates<Layer> {
  LayerUpdates.from(super.previous, super.current, String objectName)
      : super.from(objectName: objectName);
}
