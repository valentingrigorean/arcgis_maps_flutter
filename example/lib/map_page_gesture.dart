import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapPageGesture extends StatefulWidget {
  const MapPageGesture({Key? key}) : super(key: key);

  @override
  State<MapPageGesture> createState() => _MapPageGestureState();
}

class _MapPageGestureState extends State<MapPageGesture> {
  String? text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ArcgisMapView(
            map: const ArcGISMap.fromBasemap(
              Basemap.fromStyle(
                basemapStyle: BasemapStyle.arcGISCommunity,
              ),
            ),
            interactionOptions: const InteractionOptions(
              isMagnifierEnabled: false,
              allowMagnifierToPan: false,
            ),
            onTap: (_, point) {
              debugPrint('Tap: $point');
              setState(() {
                text = 'OnTap: $point';
              });
            },
            onLongPress: (_, point) {
              debugPrint('LongPress: $point');
              setState(() {
                text = 'OnLongPress: $point';
              });
            },
            onLongPressEnd: (_, point) {
              debugPrint('LongPressEnd: $point');
              setState(() {
                text = null;
              });
            },
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
