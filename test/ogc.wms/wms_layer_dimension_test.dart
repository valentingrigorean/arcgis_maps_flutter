import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("WmsLayerDimension", () {
    group('WmsLayerTimeDimensionExtension', () {
      test('The month of September 2002', () {
        var layerDimension = const WmsLayerDimension(
          name: 'time',
          units: 'ISO8601',
          extent: '2002-09-01T00:00:00.0Z/P1M',
        );

        final timeDimension = layerDimension.timeDimension;

        assert(timeDimension != null);
        assert(timeDimension!.dates.length == 1);
        assert(timeDimension!.dates[0].timeExtent.endTime ==
            DateTime.parse('2002-09-31T00:00:00.0Z'));
      });

      test('The entire day of December 25, 2010', () {
        var layerDimension = const WmsLayerDimension(
          name: 'time',
          units: 'ISO8601',
          extent: '2010-12-25T00:00:00.0Z/P1D',
        );

        final timeDimension = layerDimension.timeDimension;

        assert(timeDimension != null);
        assert(timeDimension!.dates.length == 1);
        assert(timeDimension!.dates[0].timeExtent.startTime!.day + 1 ==
            timeDimension.dates[0].timeExtent.endTime!.day);
      });

      test('The entire day preceding December 25, 2010', () {
        var layerDimension = const WmsLayerDimension(
          name: 'time',
          units: 'ISO8601',
          extent: 'P1D/2010-12-25T00:00:00.0Z',
        );

        final timeDimension = layerDimension.timeDimension;

        assert(timeDimension != null);
        assert(timeDimension!.dates.length == 1);
        assert(timeDimension!.dates[0].timeExtent.startTime!.day == 24);
      });

      test('36 hours preceding the current time', () {
        var layerDimension = const WmsLayerDimension(
          name: 'time',
          units: 'ISO8601',
          extent: 'PT36H/PRESENT',
        );

        final timeDimension = layerDimension.timeDimension;

        assert(timeDimension != null);
        assert(timeDimension!.dates.length == 1);
        assert(timeDimension!.dates[0].timeExtent.startTime!.hour ==
            DateTime.now().toUtc().subtract(const Duration(hours: 36)).hour);
      });

      test('The month of September 2002', () {
        var layerDimension = const WmsLayerDimension(
          name: 'time',
          units: 'ISO8601',
          extent: '2002-09',
        );

        final timeDimension = layerDimension.timeDimension;
        var startDate = DateTime.parse('2002-09-01T00:00:00.0Z');
        var endDate = DateTime.parse('2002-09-30T23:59:59.999Z');

        assert(timeDimension != null);
        assert(timeDimension!.dates.length == 1);
        assert(timeDimension!.dates[0].timeExtent.startTime == startDate);
        assert(timeDimension!.dates[0].timeExtent.endTime == endDate);
      });

      test('The day of December 25, 2010', () {
        var layerDimension = const WmsLayerDimension(
          name: 'time',
          units: 'ISO8601',
          extent: '2010-12-25',
        );

        final timeDimension = layerDimension.timeDimension;
        var startDate = DateTime.parse('2010-12-25T00:00:00.0Z');
        var endDate = DateTime.parse('2010-12-25T23:59:59.999Z');

        assert(timeDimension != null);
        assert(timeDimension!.dates.length == 1);
        assert(timeDimension!.dates[0].timeExtent.startTime == startDate);
        assert(timeDimension!.dates[0].timeExtent.endTime == endDate);
      });

      test('start/end with interval', () {
        var layerDimension = const WmsLayerDimension(
          name: 'time',
          units: 'ISO8601',
          extent: '2020-09-01T00:00:00.000Z/2021-09-17T07:30:00.000Z/PT15M',
        );

        final timeDimension = layerDimension.timeDimension;
        var startDate = DateTime.parse('2020-09-01T00:00:00.000Z');
        var endDate = DateTime.parse('2021-09-17T07:30:00.000Z');

        assert(layerDimension.timeDimension != null);
        assert(timeDimension!.dates[0].timeExtent.startTime == startDate);
        assert(timeDimension!.dates[0].timeExtent.endTime == endDate);
        assert(
          timeDimension!.dates[0].interval ==
              const IsoDurationValues(
                duration: Duration(),
                months: 15,
                years: 0,
              ),
        );
      });
    });
  });
}
