part of arcgis_maps_flutter;

enum WmsVersion {
  v1_1_0,
  v1_1_1,
  v1_3_0,
}

extension WmsVersionExtension on WmsVersion {
  String get stringValue {
    switch (this) {
      case WmsVersion.v1_1_0:
        return '1.1.0';
      case WmsVersion.v1_1_1:
        return '1.1.1';
      case WmsVersion.v1_3_0:
        return '1.3.0';
    }
  }
}
