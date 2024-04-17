import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapPageGeodesicSector extends StatefulWidget {
  const MapPageGeodesicSector({super.key});

  @override
  State<MapPageGeodesicSector> createState() => _MapPageGeodesicSectorState();
}

class _MapPageGeodesicSectorState extends State<MapPageGeodesicSector> {
  late final ArcgisMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geodesic Sector'),
      ),
      body: ArcgisMapView(
        onMapCreated: (controller) {
          _mapController = controller;
          _mapController.createOrUpdateGraphicsOverlay(
              const GraphicsOverlay(id: 'default'));
        },
        map: const ArcGISMap.fromBasemap(
          Basemap.fromStyle(
            basemapStyle: BasemapStyle.arcGISCommunity,
          ),
        ),
        onTap: (screenPoint) async {
          final point = await _mapController.screenToLocation(screenPoint);
          final geometry = await GeometryEngine.geodesicSector(
            GeodesicSectorParameters(
              center: point!,
              semiAxis1Length: 2300,
              semiAxis2Length: 300,
              startDirection: 25,
              sectorAngle: 100,
              geometryType: GeometryType.polygon,
            ),
          );

          await _mapController.clearGraphicsOverlay('default');
          if (geometry is Polygon) {
            _mapController.addGraphicsToOverlay(
              'default',
              [
                Graphic(
                  graphicId: 'geodesicSector',
                  geometry: geometry,
                  symbol: SimpleFillSymbol(
                    style: SimpleFillSymbolStyle.solid,
                    color: Colors.blue.withOpacity(0.5),
                    outline: const SimpleLineSymbol(
                      style: SimpleLineSymbolStyle.solid,
                      color: Colors.red,
                      width: 2,
                    ),
                  ),
                ),
              ],
            );
          }
          if (geometry is Polyline) {
            _mapController.addGraphicsToOverlay(
              'default',
              [
                Graphic(
                  graphicId: 'geodesicSector',
                  geometry: geometry,
                  symbol: const SimpleLineSymbol(
                    style: SimpleLineSymbolStyle.dash,
                    color: Colors.red,
                    width: 2,
                    markerStyle: SimpleLineSymbolMarkerStyle.arrow,
                    markerPlacement:
                        SimpleLineSymbolMarkerPlacement.beginAndEnd,
                  ),
                ),
              ],
            );
          }
        },
        interactionOptions: const InteractionOptions(
          isMagnifierEnabled: false,
          allowMagnifierToPan: false,
        ),
      ),
    );
  }
}
