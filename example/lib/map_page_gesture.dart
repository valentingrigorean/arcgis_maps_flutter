import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapPageGesture extends StatefulWidget {
  const MapPageGesture({Key? key}) : super(key: key);

  @override
  _MapPageGestureState createState() => _MapPageGestureState();
}

class _MapPageGestureState extends State<MapPageGesture> {
  String? text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ArcgisMapView(
            map: ArcGISMap.imagery(),
            onTap: (point) {
              setState(() {
                text = 'OnTap: $point';
              });
            },
            onLongPress: (point) {
              setState(() {
                text = 'OnLongPress: $point';
              });
            },
            interactionOptions: const InteractionOptions(
              isMagnifierEnabled: false,
              allowMagnifierToPan: false,
            ),
          ),
          if (text != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SafeArea(
                    child: Text(
                      text!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
