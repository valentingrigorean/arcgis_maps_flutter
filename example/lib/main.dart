import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter_example/map_page.dart';
import 'package:arcgis_maps_flutter_example/map_page_legend.dart';
import 'package:arcgis_maps_flutter_example/map_page_scalerbar.dart';
import 'package:arcgis_maps_flutter_example/scene_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ArcGISRuntimeEnvironment.setApiKey('test');
  final result = await ArcGISRuntimeEnvironment.setLicense('licenseKey');
  await dotenv.load(fileName: ".env");

  print(result);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MainPage());
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
