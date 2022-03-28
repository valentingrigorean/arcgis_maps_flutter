import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class MapPageScrollingList extends StatelessWidget {
  const MapPageScrollingList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scrolling List'),
      ),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 300,
            child: ArcgisMapView(
              map: ArcGISMap.imageryWithLabels(),
              gestureRecognizers: {
                Factory<OneSequenceGestureRecognizer>(
                  () => HorizontalDragGestureRecognizer(),
                ),
              },
            ),
          );
        },
      ),
    );
  }
}
