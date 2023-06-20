
import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter_example/utils/credentials.dart';
import 'package:arcgis_maps_flutter_example/utils/models.dart';
import 'package:flutter/material.dart';


const Portal _kSnlaArcgisPortal = Portal(
  url: 'https://snla.maps.arcgis.com/'
);

Map<GeomapTransportType, Layer> _geomapLayersMap = {
  GeomapTransportType.bus: FeatureLayer.fromUrl(
      'https://services.geodataonline.no/arcgis/rest/services/Geomap_UTM33_EUREF89/GeomapSamferdsel/FeatureServer/1',
      credential: geodataCredentials),
  GeomapTransportType.subway: FeatureLayer.fromUrl(
    'https://services.geodataonline.no/arcgis/rest/services/Geomap_UTM33_EUREF89/GeomapSamferdsel/FeatureServer/2',
    credential: geodataCredentials,
  ),
  GeomapTransportType.tram: FeatureLayer.fromUrl(
    'https://services.geodataonline.no/arcgis/rest/services/Geomap_UTM33_EUREF89/GeomapSamferdsel/FeatureServer/3',
    credential: geodataCredentials,
  ),
  GeomapTransportType.ferry: FeatureLayer.fromUrl(
    'https://services.geodataonline.no/arcgis/rest/services/Geomap_UTM33_EUREF89/GeomapSamferdsel/FeatureServer/4',
    credential: geodataCredentials,
  ),
  GeomapTransportType.train: FeatureLayer.fromUrl(
    'https://services.geodataonline.no/arcgis/rest/services/Geomap_UTM33_EUREF89/GeomapSamferdsel/FeatureServer/5',
    credential: geodataCredentials,
  ),
  GeomapTransportType.airports: FeatureLayer.fromUrl(
    'https://services.geodataonline.no/arcgis/rest/services/Geomap_UTM33_EUREF89/GeomapSamferdsel/FeatureServer/6',
    credential: geodataCredentials,
  ),
  GeomapTransportType.chargingStation: FeatureLayer.fromUrl(
    'https://services.geodataonline.no/arcgis/rest/services/Geomap_UTM33_EUREF89/GeomapSamferdsel/FeatureServer/7',
    credential: geodataCredentials,
  ),
  GeomapTransportType.tollStation: FeatureLayer.fromUrl(
    'https://services.geodataonline.no/arcgis/rest/services/Geomap_UTM33_EUREF89/GeomapSamferdsel/FeatureServer/8',
    credential: geodataCredentials,
  ),
  GeomapTransportType.restArea: FeatureLayer.fromUrl(
    'https://services.geodataonline.no/arcgis/rest/services/Geomap_UTM33_EUREF89/GeomapSamferdsel/FeatureServer/9',
    credential: geodataCredentials,
  ),
  GeomapTransportType.webcamAlongTheRoad: FeatureLayer.fromUrl(
    'https://services.geodataonline.no/arcgis/rest/services/Geomap_UTM33_EUREF89/GeomapSamferdsel/FeatureServer/10',
    credential: geodataCredentials,
  ),
  GeomapTransportType.trafficVolume: FeatureLayer.fromUrl(
    'https://services.geodataonline.no/arcgis/rest/services/Geomap_UTM33_EUREF89/GeomapSamferdsel/FeatureServer/11',
    credential: geodataCredentials,
  ),
  GeomapTransportType.trafficVolumeWithLabels: FeatureLayer.fromUrl(
    'https://services.geodataonline.no/arcgis/rest/services/Geomap_UTM33_EUREF89/GeomapSamferdsel/FeatureServer/12',
    credential: geodataCredentials,
  ),
  GeomapTransportType.parkingSpace: FeatureLayer.fromUrl(
    'https://services.geodataonline.no/arcgis/rest/services/Geomap_UTM33_EUREF89/GeomapSamferdsel/FeatureServer/14',
    credential: geodataCredentials,
  ),
  GeomapTransportType.chargePoint: FeatureLayer.fromUrl(
    'https://services.geodataonline.no/arcgis/rest/services/Geomap_UTM33_EUREF89/GeomapSamferdsel/FeatureServer/15',
    credential: geodataCredentials,
  ),
  GeomapTransportType.aviationObstacleLine: FeatureLayer.fromUrl(
    'https://services.geodataonline.no/arcgis/rest/services/Geomap_UTM33_EUREF89/GeomapSamferdsel/FeatureServer/18',
    credential: geodataCredentials,
  ),
  GeomapTransportType.aviationObstacleLinePoint: FeatureLayer.fromUrl(
    'https://services.geodataonline.no/arcgis/rest/services/Geomap_UTM33_EUREF89/GeomapSamferdsel/FeatureServer/19',
    credential: geodataCredentials,
  ),
  GeomapTransportType.aviationObstaclesPoint: FeatureLayer.fromUrl(
    'https://services.geodataonline.no/arcgis/rest/services/Geomap_UTM33_EUREF89/GeomapSamferdsel/FeatureServer/20',
    credential: geodataCredentials,
  ),
  GeomapTransportType.roadCenterLine: FeatureLayer.fromUrl(
    'https://services.geodataonline.no/arcgis/rest/services/Geomap_UTM33_EUREF89/GeomapSamferdsel/FeatureServer/21',
    credential: geodataCredentials,
  ),
};

const List<MapTypeOptions> _supportedMapsTypes = [
  MapTypeOptions(
    mapUrl: MapTypeCreateParams(
      url:
      'https://services.geodataonline.no/arcgis/rest/services/GeocacheVector/GeocacheNordenBasis/VectorTileServer',
      createType: MapCreateType.vectorTiled,
    ),
    darkMapUrl: MapTypeCreateParams(
      url:
      'https://services.geodataonline.no/arcgis/rest/services/GeocacheVector/GeocacheNordenKanvasMork/VectorTileServer',
      createType: MapCreateType.vectorTiled,
    ),
    mapType: MapType.standard,
  ),
  MapTypeOptions(
    mapUrl: MapTypeCreateParams(
      url:
      'https://services.geodataonline.no/arcgis/rest/services/GeocacheVector/GeocacheNordenBasisTerreng/VectorTileServer',
      createType: MapCreateType.vectorTiled,
    ),
    mapType: MapType.standardTerrain,
  ),
  MapTypeOptions(
    mapUrl: MapTypeCreateParams(
      url:
      'https://services.geodataonline.no/arcgis/rest/services/GeocacheVector/GeocacheNordenGraatone/VectorTileServer',
      createType: MapCreateType.vectorTiled,
    ),
    mapType: MapType.grayTone,
  ),
  MapTypeOptions(
    mapUrl: MapTypeCreateParams(
      url:
      'https://services.geodataonline.no/arcgis/rest/services/GeocacheVector/GeocacheNordenGraatoneTerreng/VectorTileServer',
      createType: MapCreateType.vectorTiled,
    ),
    mapType: MapType.grayToneTerrain,
  ),
  MapTypeOptions(
    mapUrl: MapTypeCreateParams(
      url:
      'https://services.geodataonline.no/arcgis/rest/services/Geocache_UTM33_EUREF89/GeocacheBasis/MapServer',
      createType: MapCreateType.tiled,
    ),
    mapType: MapType.raster,
  ),
  MapTypeOptions(
    mapUrl: MapTypeCreateParams(
      url:
      'https://services.geodataonline.no/arcgis/rest/services/Geocache_UTM33_EUREF89/GeocacheBilder/MapServer',
      createType: MapCreateType.tiled,
    ),
    mapType: MapType.satelit,
    useDarkScaleBar: true,
  ),
  MapTypeOptions(
    mapUrl: MapTypeCreateParams(
      url:
      'https://services.geodataonline.no/arcgis/rest/services/Geocache_UTM33_EUREF89/GeocacheBilder/MapServer',
      createType: MapCreateType.tiled,
    ),
    mapType: MapType.satelitWorld,
    useDarkScaleBar: true,
  )
];

final LocatorTask _geodataLocator = LocatorTask(
  url:
  'https://services.geodataonline.no/arcgis/rest/services/Geosok/GeosokLokasjon2/GeocodeServer',
);

final LocatorTask _esriLocator = LocatorTask(
  url: 'https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer',
);

final RouteTask _geodataRouteTask = RouteTask(
  url:
  'https://services.geodataonline.no/arcgis/rest/services/Geosok/GeosokRute3/NAServer/Route',
  credential: geodataCredentials,
);

final RouteTask _esriRouteTask = RouteTask(
  url:
  'https://route-api.arcgis.com/arcgis/rest/services/World/Route/NAServer/Route_World',
);

class ArcgisMapsUtils {

  ArcgisMapsUtils._();

  static LocatorTask get geodataLocatorTask => _geodataLocator;

  static LocatorTask get esriLocatorTask => _esriLocator;

  static RouteTask get geodataRouteTask => _geodataRouteTask;

  static RouteTask get esriRouteTask => _esriRouteTask;

  static List<MapTypeOptions> getSupportedMaps() => _supportedMapsTypes;

  static MapTypeOptions get defaultMap => _supportedMapsTypes.first;

  static MapTypeOptions get defaultSatelliteMap =>
      _supportedMapsTypes.firstWhere((e) => e.mapType == MapType.satelit);

  static ArcGISMap createMap(
      MapTypeOptions mapTypeOptions, Brightness brightness) {
    if (mapTypeOptions.mapType == MapType.satelitWorld) {
      return const ArcGISMap.fromBasemap(
          Basemap.fromStyle(basemapStyle: BasemapStyle.arcGISImageryLabels),
        );
    }
    final layer = _createBasemapLayer(mapTypeOptions, brightness);
    return ArcGISMap.fromBasemap(Basemap.fromBaseLayer(layer));
  }


  static Layer getGeomapTransportLayerFromType(
      GeomapTransportType transportType) =>
      _geomapLayersMap[transportType]!;

  static Set<Layer> getAviationObstacleLayers() => {
    // Lines from FKB
    const FeatureLayer.fromPortalItem(
      layerId: LayerId('946653e73a90455b81afc9472ea465a5'),
      portalItem: PortalItem(
        portal: _kSnlaArcgisPortal,
        itemId: '946653e73a90455b81afc9472ea465a5',
      ),
      portalItemLayerId: 0,
    ),
    //Lines from NRL
    const FeatureLayer.fromPortalItem(
      layerId: LayerId('4962793a556c45318af207fb5d11a8c3'),
      portalItem: PortalItem(
        portal: _kSnlaArcgisPortal,
        itemId: '4962793a556c45318af207fb5d11a8c3',
      ),
      portalItemLayerId: 0,
    ),
    // Smaler point
    const FeatureLayer.fromPortalItem(
      layerId: LayerId('a60d5cd6885b49adae10ad3bcb8b3137'),
      portalItem: PortalItem(
        portal: _kSnlaArcgisPortal,
        itemId: 'a60d5cd6885b49adae10ad3bcb8b3137',
      ),
      portalItemLayerId: 0,
    ),
    //Points from NRL
    const FeatureLayer.fromPortalItem(
      layerId: LayerId('f6ab0a19e1164cc1beb7d7cd566d2429'),
      portalItem: PortalItem(
        portal: _kSnlaArcgisPortal,
        itemId: 'f6ab0a19e1164cc1beb7d7cd566d2429',
      ),
      portalItemLayerId: 0,
    ),
    // High Points from NRL
    const FeatureLayer.fromPortalItem(
      layerId: LayerId('7cb09387617c416b96ed636126f90de5'),
      portalItem: PortalItem(
        portal: _kSnlaArcgisPortal,
        itemId: '7cb09387617c416b96ed636126f90de5',
      ),
      portalItemLayerId: 0,
    ),
  };

  static Layer getSlopeMapLayer() => TiledLayer.fromUrl(
    'https://services.geodataonline.no/arcgis/rest/services/Geocache_UTM33_EUREF89/GeocacheHelning/MapServer',
    opacity: 0.4,
  );

  static Set<Layer> getAvalancheLayers() => {
    MapImageLayer.fromUrl(
      'https://gis3.nve.no/arcgis/rest/services/wmts/KastWMTS/MapServer',
      credential: geodataCredentials,
      opacity: 0.4,
    ),
  };

  static Set<Layer> getDepthDataLayers() => {
    WmsLayer.fromUrl(
      'https://wms.geonorge.no/skwms1/wms.dybdedata2?service=WMS&request=GetCapabilities',
      layersName: [
        'grunne',
        'flytedokk',
        'Dybdepunkt',
        //'Dybdelag',
        'Dybdekontur',
      ],
    ),
    // lakes layers
    FeatureLayer.fromUrl(
      'https://nve.geodataonline.no/arcgis/rest/services/Innsjodatabase2/MapServer/1',
      opacity: 0.4,
    ),
    FeatureLayer.fromUrl(
      'https://nve.geodataonline.no/arcgis/rest/services/Innsjodatabase2/MapServer/2',
      opacity: 0.4,
    ),
  };

  static Set<Layer> getHydropowerLayers() => {
    FeatureLayer.fromUrl(
        'https://nve.geodataonline.no/arcgis/rest/services/Vannkraft1/MapServer/0'),
    FeatureLayer.fromUrl(
        'https://nve.geodataonline.no/arcgis/rest/services/Vannkraft1/MapServer/1'),
    FeatureLayer.fromUrl(
        'https://nve.geodataonline.no/arcgis/rest/services/Vannkraft1/MapServer/2'),
    FeatureLayer.fromUrl(
        'https://nve.geodataonline.no/arcgis/rest/services/Vannkraft1/MapServer/3'),
    FeatureLayer.fromUrl(
        'https://nve.geodataonline.no/arcgis/rest/services/Vannkraft1/MapServer/4'),
    FeatureLayer.fromUrl(
        'https://nve.geodataonline.no/arcgis/rest/services/Vannkraft1/MapServer/5'),
  };

  static Set<Layer> getIceLayers() => {
    FeatureLayer.fromUrl(
        'https://nve.geodataonline.no/arcgis/rest/services/SvekketIs1/MapServer/1'),
    FeatureLayer.fromUrl(
        'https://nve.geodataonline.no/arcgis/rest/services/SvekketIs1/MapServer/3'),
    FeatureLayer.fromUrl(
        'https://nve.geodataonline.no/arcgis/rest/services/SvekketIs1/MapServer/4'),
    FeatureLayer.fromUrl(
        'https://nve.geodataonline.no/arcgis/rest/services/SvekketIs1/MapServer/5'),
  };

  static Layer getHeightMapLayer() => VectorTileLayer.fromUrl(
      'https://services.geodataonline.no/arcgis/rest/services/GeocacheVector/GeocacheHoydekurver/VectorTileServer');

  static Layer getHeightMapLayerWM() => VectorTileLayer.fromUrl(
      'https://services.geodataonline.no/arcgis/rest/services/GeocacheVector/GeocacheHoydekurver_WM/VectorTileServer');

  static Layer getNatureConservationAreaLayer() =>
      const FeatureLayer.fromPortalItem(
        layerId: LayerId('natureConservationAreaLayer'),
        portalItem: PortalItem(
          portal: _kSnlaArcgisPortal,
          itemId: '3b00906ddbb14014b36bf6248f2b74c5',
        ),
        portalItemLayerId: 1,
      );

  static Layer _createBasemapLayer(
      MapTypeOptions mapTypeOptions, Brightness brightness) {
    final createParams = brightness == Brightness.dark
        ? mapTypeOptions.darkMapUrl ?? mapTypeOptions.mapUrl
        : mapTypeOptions.mapUrl;

    switch (createParams.createType) {
      case MapCreateType.tiled:
        return TiledLayer.fromUrl(createParams.url);
      case MapCreateType.vectorTiled:
        return VectorTileLayer.fromUrl(createParams.url);
    }
  }
}