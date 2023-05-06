import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapPageGeodesicSector extends StatefulWidget {
  const MapPageGeodesicSector({Key? key}) : super(key: key);

  @override
  State<MapPageGeodesicSector> createState() => _MapPageGeodesicSectorState();
}

class _MapPageGeodesicSectorState extends State<MapPageGeodesicSector> {
  final Set<PolygonMarker> polygons = {};
  final Set<PolylineMarker> polylines = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geodesic Sector'),
      ),
      body: ArcgisMapView(
        map: ArcGISMap.imagery(),
        onTap: (_,point) async {
          final geometry = await GeometryEngine.geodesicSector(
            GeodesicSectorParameters(
              center: point,
              semiAxis1Length: 2300,
              semiAxis2Length: 300,
              startDirection: 25,
              sectorAngle: 100,
              geometryType: GeometryType.polygon,
            ),
          );

          if (geometry is Polygon) {
            final polygon = geometry;
            polygons.add(
              PolygonMarker(
                polygonId: PolygonId(polygons.length.toString()),
                points: polygon.points
                    .expand((e) => e)
                    .map((e) =>
                        e.copyWithSpatialReference(polygon.spatialReference))
                    .toList(),
                strokeWidth: 2,
                strokeColor: Colors.red,
                fillColor: Colors.blueAccent.withOpacity(0.5),
              ),
            );
          }
          if (geometry is Polyline) {
            final polyline = geometry;
            polylines.add(
              PolylineMarker(
                polylineId: PolylineId(polylines.length.toString()),
                points: polyline.points
                    .expand((e) => e)
                    .map((e) =>
                        e.copyWithSpatialReference(polyline.spatialReference))
                    .toList(),
                color: Colors.red,
              ),
            );
          }

          if (mounted) {
            setState(() {});
          }
        },
        polygons: polygons,
        polylines: polylines,
        interactionOptions: const InteractionOptions(
          isMagnifierEnabled: false,
          allowMagnifierToPan: false,
        ),
      ),
    );
  }
}
