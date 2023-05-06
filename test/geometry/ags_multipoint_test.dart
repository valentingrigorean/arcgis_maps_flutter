import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("create objects", () {
    test('createMultiPoints fromNullJson ExpectedNull', () {
      var result = Multipoint.fromJson(null);
      assert(result == null);
    });

    test('createMultiPoints fromJson ExpectedData', () {
      var result = Multipoint.fromJson({
        "spatialReference": {"wkid": 4326, "wktext": "wktext"},
        "points": [
          [1.0, 2.0],
          [3.0, 4.0]
        ]
      });
      expect(result?.spatialReference, SpatialReference.wgs84());
      expect(result?.geometryType, GeometryType.multipoint);
      expect(result?.points,
          [const Point(x: 1.0, y: 2.0), const Point(x: 3.0, y: 4.0)]);
    });

    test('createMultiPoints fromPoints ExpectedData', () {
      var result = Multipoint(
          points: const [Point(x: 1.0, y: 2.0), Point(x: 3.0, y: 4.0)],
          spatialReference: SpatialReference.wgs84());
      expect(result.spatialReference, SpatialReference.wgs84());
      expect(result.points,
          [const Point(x: 1.0, y: 2.0), const Point(x: 3.0, y: 4.0)]);
    });
  });

  group("multiPoint to Json", () {
    test('multiPoint toJson ExpectedData', () {
      var data = Multipoint(
          points: const [Point(x: 1.0, y: 2.0), Point(x: 3.0, y: 4.0)],
          spatialReference: SpatialReference.wgs84());

      var result = data.toJson();
      expect(result, {
        "spatialReference": {"wkid": 4326},
        "points": [
          [1.0, 2.0],
          [3.0, 4.0]
        ],
        "geometryType": 5,
      });
    });
  });
}
