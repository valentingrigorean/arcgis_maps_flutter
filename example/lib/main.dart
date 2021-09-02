import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter_example/map_page.dart';
import 'package:arcgis_maps_flutter_example/map_page_assets_marker.dart';
import 'package:arcgis_maps_flutter_example/map_page_auto_pan_mode.dart';
import 'package:arcgis_maps_flutter_example/map_page_legend.dart';
import 'package:arcgis_maps_flutter_example/map_page_scalerbar.dart';
import 'package:arcgis_maps_flutter_example/map_page_screen_location.dart';
import 'package:arcgis_maps_flutter_example/scene_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ArcGISRuntimeEnvironment.setApiKey('test');
  final result = await ArcGISRuntimeEnvironment.setLicense('licenseKey');
  await dotenv.load(fileName: ".env");
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Map 2d'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MapPage()));
              },
            ),
            ElevatedButton(
              child: Text('Map ScaleBar'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapPageScaleBar(),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: Text('Map Legend'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapPageLegend(),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: Text('Map Asset Marker'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapPageASsetsMarker(),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: Text('Map AutoPanMode'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapPageAutoPanMode(),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: Text('Map ScreenLocation'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapPageScreenLocation(),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: Text('Scene 3d'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ScenePage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
