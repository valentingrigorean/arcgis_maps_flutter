import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("WmsService", () {
    group('getServiceInfo', () {
      test('eumetsat', () async {
        var wmsService = const WmsService();
        var serviceInfo = await wmsService
            .getServiceInfo('https://view.eumetsat.int/geoserver/wms');
        assert(serviceInfo != null);
      });

      test('naturvardsverket', () async {
        var wmsService = const WmsService();
        var serviceInfo = await wmsService
            .getServiceInfo('https://nvgis.naturvardsverket.se/geoserver/lavinprognoser/wms');
        assert(serviceInfo != null);
      });
    });
  });
}
