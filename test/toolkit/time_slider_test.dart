import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TimeSliderController', () {
    test('Generate timeSteps interval 5min', () {
      final controller = TimeSliderController();
      controller.fullExtent = TimeExtent(
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 1)),
      );

      expect(controller.timeSteps.length, 12);
    });

    test('Generate timeSteps interval 1min', () {
      final controller = TimeSliderController(
          timeStepInterval: const TimeValue(
        duration: 1,
        unit: TimeUnit.minutes,
      ));
      controller.fullExtent = TimeExtent(
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 1)),
      );

      expect(controller.timeSteps.length, 60);
    });
  });
}
