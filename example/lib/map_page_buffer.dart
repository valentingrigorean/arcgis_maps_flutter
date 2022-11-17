import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MapPageBuffer extends StatefulWidget {
  const MapPageBuffer({Key? key}) : super(key: key);

  @override
  State<MapPageBuffer> createState() => _MapPageBufferState();
}

class _MapPageBufferState extends State<MapPageBuffer> {
  int _currentBufferType = 0;
  Polygon? _polygon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buffer'),
      ),
      body: Stack(
        children: [
          ArcgisMapView(
            map: ArcGISMap.imagery(),
            polygons: _polygon == null ? const {} : {_polygon!},
            onTap: (screenPoint, position) async {
              AGSPolygon? polygon;
              if (_currentBufferType == 0) {
                polygon = await GeometryEngine.bufferGeometry(
                    geometry: position, distance: 1000);
              } else {
                polygon = await GeometryEngine.geodeticBufferGeometry(
                  geometry: position,
                  distance: 1000,
                  distanceUnit: LinearUnitId.meters,
                  maxDeviation: double.nan,
                  curveType: GeodeticCurveType.shapePreserving,
                );
              }

              if (polygon == null) {
                _polygon = null;
              } else {
                _polygon = Polygon(
                  polygonId: const PolygonId('buffer'),
                  points: polygon.points.first,
                  fillColor: Colors.red,
                  strokeWidth: 2,
                  strokeStyle: SimpleLineSymbolStyle.dash,
                );
                setState(() {});
              }
            },
          ),
          Positioned(
            top: 16,
            left: 16,
            child: CupertinoSegmentedControl(
              onValueChanged: (int newValue) {
                setState(() {
                  _currentBufferType = newValue;
                });
              },
              groupValue: _currentBufferType,
              children: const {
                0: Text('Buffer'),
                1: Text('GeodeticBuffer'),
              },
            ),
          )
        ],
      ),
    );
  }
}
