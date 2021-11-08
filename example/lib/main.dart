// ignore_for_file: avoid_print

import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter_example/map_page.dart';
import 'package:arcgis_maps_flutter_example/map_page_assets_marker.dart';
import 'package:arcgis_maps_flutter_example/map_page_auto_pan_mode.dart';
import 'package:arcgis_maps_flutter_example/map_page_dynamic_layer.dart';
import 'package:arcgis_maps_flutter_example/map_page_gesture.dart';
import 'package:arcgis_maps_flutter_example/map_page_group_layer.dart';
import 'package:arcgis_maps_flutter_example/map_page_layers_change.dart';
import 'package:arcgis_maps_flutter_example/map_page_legend.dart';
import 'package:arcgis_maps_flutter_example/map_page_marker_rotation.dart';
import 'package:arcgis_maps_flutter_example/map_page_markers_visibility_filter.dart';
import 'package:arcgis_maps_flutter_example/map_page_polygon.dart';
import 'package:arcgis_maps_flutter_example/map_page_portal.dart';
import 'package:arcgis_maps_flutter_example/map_page_scalerbar.dart';
import 'package:arcgis_maps_flutter_example/map_page_screen_location.dart';
import 'package:arcgis_maps_flutter_example/map_page_time_slider.dart';
import 'package:arcgis_maps_flutter_example/scene_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await ArcGISRuntimeEnvironment.setApiKey(dotenv.env['apiKey'] ?? 'apiKey');
  final result = await ArcGISRuntimeEnvironment.setLicense(dotenv.env['licenseKey'] ?? 'licenseKey');
  final apiVersion = await ArcGISRuntimeEnvironment.getAPIVersion();

  print(result);
  runApp(
    MyApp(
      apiVersion: apiVersion,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.apiVersion}) : super(key: key);

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
                child: const Text('Map Dynamic Layer'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapPageDynamicLayer(),
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
                child: const Text('Map Time Slider'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapPageTimeSlider(),
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
                child: const Text('Map Layers changed'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapPageLayersChange(),
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
                      builder: (context) => const MapPageMarkersVisibilityFilter(),
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const ScenePage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
