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

      test('halo', () async {
        var wmsService = const WmsService();
        var serviceInfo = await wmsService
            .getServiceInfo('https://halo-wms.met.no/halo/default.map?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities');
        assert(serviceInfo != null);
      });

    });
  });
}
