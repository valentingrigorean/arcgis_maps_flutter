import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("WmsService", () {
    group('getServiceInfo', () {

      test('Met.no data nowcast', () async {
        var wmsService = const WmsService();
        var serviceInfo = await wmsService
            .getServiceInfo('https://public-wms.met.no/verportal/radar_nowcast.map?');
        assert(serviceInfo != null);
      });

      test('Met.no data', () async {
        var wmsService = const WmsService();
        var serviceInfo = await wmsService
            .getServiceInfo('https://public-wms.met.no/verportal/verportal.map?');
        assert(serviceInfo != null);

      });

      test('SMHI data', () async {
        var wmsService = const WmsService();
        var serviceInfo = await wmsService
            .getServiceInfo('https://wts2.smhi.se/tile/baltrad?');
        assert(serviceInfo != null);
      });


      test('EUMETSAT data', () async {
        var wmsService = const WmsService();
        var serviceInfo = await wmsService
            .getServiceInfo('https://view.eumetsat.int/geoserver/wms');
        assert(serviceInfo != null);
      });

      test('Met.no data (HALO)', () async {
        var wmsService = const WmsService();
        var serviceInfo = await wmsService
            .getServiceInfo('https://halo-wms.met.no/halo/default.map');
        assert(serviceInfo != null);
      });


      test('NVE Skred data', () async {
        var wmsService = const WmsService();
        var serviceInfo = await wmsService
            .getServiceInfo('https://gis3.nve.no/map/services/Bratthet/MapServer/WMSServer');
        assert(serviceInfo != null);
      });

      test('Sluttning', () async {
        var wmsService = const WmsService();
        var serviceInfo = await wmsService
            .getServiceInfo('https://nvgis.naturvardsverket.se/geoserver/lavinprognoser/wms');
        assert(serviceInfo != null);
      });


      test('BarentsWatch', () async {
        var wmsService = const WmsService();
        var serviceInfo = await wmsService
            .getServiceInfo('https://geo.barentswatch.no/geoserver/ows/bw?service=WMS&request=GetCapabilities');
        assert(serviceInfo != null);
      });
    });
  });
}
