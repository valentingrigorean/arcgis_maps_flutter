enum MapCreateType {
  tiled,
  vectorTiled,
}

enum MapType {
  standard,
  standardTerrain,
  grayTone,
  grayToneTerrain,
  raster,
  satelit,
  satelitWorld,
}

enum GeomapTransportType {
  bus,
  subway,
  tram,
  ferry,
  train,
  airports,
  chargingStation,
  tollStation,
  restArea,
  webcamAlongTheRoad,
  trafficVolume,
  trafficVolumeWithLabels,
  parkingSpace,
  chargePoint,
  aviationObstacleLine,
  aviationObstacleLinePoint,
  aviationObstaclesPoint,
  roadCenterLine
}

class MapTypeCreateParams {
  const MapTypeCreateParams({
    required this.url,
    required this.createType,
  });

  final String url;
  final MapCreateType createType;
}

class MapTypeOptions {
  final MapTypeCreateParams mapUrl;
  final MapTypeCreateParams? darkMapUrl;
  final MapType mapType;
  final bool? useDarkScaleBar;

  const MapTypeOptions({
    required this.mapUrl,
    this.darkMapUrl,
    required this.mapType,
    this.useDarkScaleBar,
  });
}
