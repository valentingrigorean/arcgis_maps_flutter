import 'dart:io';
import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class MobilePageMobileMapPackage extends StatefulWidget {
  const MobilePageMobileMapPackage({Key? key}) : super(key: key);

  @override
  State<MobilePageMobileMapPackage> createState() =>
      _MobilePageMobileMapPackageState();
}

class _MobilePageMobileMapPackageState
    extends State<MobilePageMobileMapPackage> {
  ArcGISMap? _offlineMap;

  @override
  void initState() {
    super.initState();
    _loadOfflineMap();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile map package'),
      ),
      body: _offlineMap == null
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : ArcgisMapView(
              map: _offlineMap!,
              onMapLoaded: (error) {
                if (error != null) {
                  debugPrint('Error: $error');
                }
              },
            ),
    );
  }

  Future<void> _loadOfflineMap() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(
        '${directory.path}/mobile_pack/Yellowstone/map.mmpk');
    final fileExists = await file.exists();

    if (!fileExists) {
      final result = await _moveMapToLocalStorage(file);
      if (!result) return;
    }

    _offlineMap = ArcGISMap.offlineMap(file.path);
    setState(() {});
  }

  Future<bool> _moveMapToLocalStorage(File file) async {
    try {
      final data = await rootBundle.load('assets/Yellowstone.mmpk');
      await file.create(recursive: true);
      await file.writeAsBytes(
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
      return true;
    } catch (e) {
      debugPrint('Error moving file: $e');
      return false;
    }
  }
}
