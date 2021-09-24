import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapPageDynamicLayer extends StatefulWidget {
  const MapPageDynamicLayer({Key? key}) : super(key: key);

  @override
  _MapPageDynamicLayerState createState() => _MapPageDynamicLayerState();
}

class _MapPageDynamicLayerState extends State<MapPageDynamicLayer> {
  final ServiceImageTiledLayer _dynamicLayer = ServiceImageTiledLayer(
    layerId: const LayerId('dynamicLayer'),
    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
    tileInfo: _createTileInfo(),
    fullExtent: Envelope(
      xMin: -20037508.3427892,
      yMin: -20037508.3427892,
      xMax: 20037508.3427892,
      yMax: 20037508.3427892,
      spatialReference: SpatialReference.webMercator(),
    ),
    subdomains: const ['a', 'b', 'c'],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Layer'),
      ),
      body: ArcgisMapView(
        map: ArcGISMap.fromBaseLayer(_dynamicLayer),
      ),
    );
  }

  static TileInfo _createTileInfo() {
    var levels = <LevelOfDetail>[];
    var resolution = 20037508.3427892 * 2 / 256;
    var scale = resolution * 96 * 39.37;
    for (int i = 0; i < 19; i++) {
      levels.add(LevelOfDetail(
        level: i,
        resolution: resolution,
        scale: scale,
      ));
      resolution /= 2;
      scale /= 2;
    }
    return TileInfo(
      dpi: 96,
      imageFormat: ImageFormat.png,
      levelOfDetails: levels,
      origin: Point(
        x: -20037508.3427892,
        y: 20037508.3427892,
        spatialReference: SpatialReference.webMercator(),
      ),
      spatialReference: SpatialReference.webMercator(),
      tileHeight: 256,
      tileWidth: 256,
    );
  }
}
