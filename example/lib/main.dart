// ignore_for_file: avoid_print

import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter_example/credential_page.dart';
import 'package:arcgis_maps_flutter_example/map_page.dart';
import 'package:arcgis_maps_flutter_example/map_page_assets_marker.dart';
import 'package:arcgis_maps_flutter_example/map_page_auto_pan_mode.dart';
import 'package:arcgis_maps_flutter_example/map_page_buffer.dart';
import 'package:arcgis_maps_flutter_example/map_page_current_location_tap.dart';
import 'package:arcgis_maps_flutter_example/map_page_export_image.dart';
import 'package:arcgis_maps_flutter_example/map_page_feature_service_offline.dart';
import 'package:arcgis_maps_flutter_example/map_page_geodesic_distance.dart';
import 'package:arcgis_maps_flutter_example/map_page_geodesic_sector.dart';
import 'package:arcgis_maps_flutter_example/map_page_geometry_engine.dart';
import 'package:arcgis_maps_flutter_example/map_page_gesture.dart';
import 'package:arcgis_maps_flutter_example/map_page_group_layer.dart';
import 'package:arcgis_maps_flutter_example/map_page_legend.dart';
import 'package:arcgis_maps_flutter_example/map_page_locator.dart';
import 'package:arcgis_maps_flutter_example/map_page_marker_from_widget.dart';
import 'package:arcgis_maps_flutter_example/map_page_marker_rotation.dart';
import 'package:arcgis_maps_flutter_example/map_page_markers.dart';
import 'package:arcgis_maps_flutter_example/map_page_markers_visibility_filter.dart';
import 'package:arcgis_maps_flutter_example/map_page_max_extent.dart';
import 'package:arcgis_maps_flutter_example/map_page_mobile_map_package.dart';
import 'package:arcgis_maps_flutter_example/map_page_offline_map.dart';
import 'package:arcgis_maps_flutter_example/map_page_polygon.dart';
import 'package:arcgis_maps_flutter_example/map_page_portal.dart';
import 'package:arcgis_maps_flutter_example/map_page_route.dart';
import 'package:arcgis_maps_flutter_example/map_page_scalerbar.dart';
import 'package:arcgis_maps_flutter_example/map_page_screen_location.dart';
import 'package:arcgis_maps_flutter_example/map_page_scrolling_list.dart';
import 'package:arcgis_maps_flutter_example/map_page_tile_cache.dart';
import 'package:arcgis_maps_flutter_example/map_page_view_insests.dart';
import 'package:arcgis_maps_flutter_example/scene_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await ArcGISEnvironment.setApiKey(dotenv.env['apiKey'] ?? 'apiKey');
  final result = await ArcGISEnvironment.setLicense(
      dotenv.env['licenseKey'] ?? 'licenseKey');
  final apiVersion = await ArcGISEnvironment.getAPIVersion();

  print(result);
  runApp(
    MyApp(
      apiVersion: apiVersion,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.apiVersion,
  }) : super(key: key);

  final String apiVersion;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(
        apiVersion: apiVersion,
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key, required this.apiVersion}) : super(key: key);

  final String apiVersion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arcgis $apiVersion'),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text('Map 2d'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const MapPage()));
                },
              ),
              ElevatedButton(
                child: const Text('Map 2d Screenshot'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const MapPageExportImage()));
                },
              ),
              ElevatedButton(
                child: const Text('Map ScaleBar'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapPageScaleBar(),
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('User location tap'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapPageCurrentLocationTap(),
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Credentials'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CredentialPage(),
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Mobile map package'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MobilePageMobileMapPackage(),
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Offline map & Sync'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapPageOfflineMap(),
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Offline tile cache map'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapPageTileCache(),
                    ),
                  );
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const MapPageFeatureServiceOffline(),
                    ),
                  );
                },
                child: const Text('Feature service offline & sync'),
              ),
              ElevatedButton(
                child: const Text('Marker generatered from widget'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapPageMarkerFromWidget(),
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Map Max Extent'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapPageMaxExtent(),
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Map Gestures'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapPageGesture(),
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Map Markers 5000'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapPageMarkers(),
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Map Scrolling list'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapPageScrollingList(),
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Map Buffers'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapPageBuffer(),
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Map Geodesic Sector'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapPageGeodesicSector(),
                    ),
                  );
                },
              ),

              ElevatedButton(
                child: const Text('Map View insets'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapPageViewInsets(),
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Map Locator'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapPageLocator(),
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Map Route'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapPageRoute(),
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Map Geodesic'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapPageGeodeticDistance(),
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Map GeometryEngine'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapPageGeometryEngine(),
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Map Group Layer'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapPageGroupLayer(),
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Map Portal feature layer'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapPagePortal(),
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Map Legend'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapPageLegend(),
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Map Page Polygon'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapPagePolygon(),
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Map Asset Marker'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapPageASsetsMarker(),
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Map Marker rotation'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapPageMarkerRotation(),
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Map Marker Visibility Filter'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const MapPageMarkersVisibilityFilter(),
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Map AutoPanMode'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapPageAutoPanMode(),
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Map ScreenLocation'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapPageScreenLocation(),
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Scene 3d'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ScenePage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
