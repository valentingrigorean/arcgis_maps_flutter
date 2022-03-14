import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('toJson', () {
    final wmsLayer = WmsLayer.fromUrl('url', layersName: ['1', '2', '3']);
    final json = wmsLayer.toJson();

    final layersName = json['layersName'];
    assert(layersName != null);
    assert(layersName is List<String>);
    if (layersName is List<String>) {
      assert(layersName.length == 3);
    }
  });
}
