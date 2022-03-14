import 'package:arcgis_maps_flutter/src/symbology/cluster_item.dart';
import 'package:fluster/fluster.dart';

class ClusterManager {
  final Fluster<CLusterItem> _fluster;

  ClusterManager({
    int minZoom = 0,
    int maxZoom = 20,
    int radius = 150,
    int extent = 2048,
    int nodeSize = 64,
  }) : _fluster = Fluster(
          minZoom: minZoom,
          maxZoom: maxZoom,
          radius: radius,
          extent: extent,
          nodeSize: nodeSize,
        );
}
