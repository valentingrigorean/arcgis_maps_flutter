import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapPageGeometryEngine extends StatefulWidget {
  const MapPageGeometryEngine({Key? key}) : super(key: key);

  @override
  State<MapPageGeometryEngine> createState() => _MapPageGeometryEngineState();
}

class _MapPageGeometryEngineState extends State<MapPageGeometryEngine> {
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
            onTap: (_,point) async {
              final projection = await GeometryEngine.project(
                point!,
                SpatialReference.wgs84(),
              );
              setState(() {
                text = 'OnTap: $projection';
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
