part of arcgis_maps_flutter;

enum BasemapStyle {
  arcGISChartedTerritory(0),
  arcGISChartedTerritoryBase(1),
  arcGISColoredPencil(2),
  arcGISCommunity(3),
  arcGISDarkGray(4),
  arcGISDarkGrayBase(5),
  arcGISDarkGrayLabels(6),
  arcGISHillshadeDark(7),
  arcGISHillshadeLight(8),
  arcGISImagery(9),
  arcGISImageryLabels(10),
  arcGISImageryStandard(11),
  arcGISLightGray(12),
  arcGISLightGrayBase(13),
  arcGISLightGrayLabels(14),
  arcGISMidcentury(15),
  arcGISModernAntique(16),
  arcGISModernAntiqueBase(17),
  arcGISNavigation(18),
  arcGISNavigationNight(19),
  arcGISNewspaper(20),
  arcGISNova(21),
  arcGISOceans(22),
  arcGISOceansBase(23),
  arcGISOceansLabels(24),
  arcGISStreets(25),
  arcGISStreetsNight(26),
  arcGISStreetsRelief(27),
  arcGISStreetsReliefBase(28),
  arcGISTerrain(29),
  arcGISTerrainBase(30),
  arcGISTerrainDetail(31),
  arcGISTopographic(32),
  arcGISTopographicBase(33),
  osmDarkGray(34),
  osmDarkGrayBase(35),
  osmDarkGrayLabels(36),
  osmLightGray(37),
  osmLightGrayBase(38),
  osmLightGrayLabels(39),
  osmStandard(40),
  osmStandardRelief(41),
  osmStandardReliefBase(42),
  osmStreets(43),
  osmStreetsRelief(44),
  osmStreetsReliefBase(45);

  const BasemapStyle(this.value);

  final int value;
}

class ArcGISMapOfflineInfo extends Equatable {
  final String path;
  final int index;

  const ArcGISMapOfflineInfo._(this.path, this.index);

  Object toJson() {
    return {
      'path': path,
      'index': index,
    };
  }

  @override
  List<Object?> get props => [path, index];
}

class ArcGISMap extends Equatable {
  const ArcGISMap._({
    this.basemap,
    this.basemapStyle,
    this.item,
    this.spatialReference,
    this.uri,
    this.offlineInfo,
  });

  const ArcGISMap.fromBasemap(Basemap basemap) : this._(basemap: basemap);

  const ArcGISMap.fromBasemapStyle(BasemapStyle basemapStyle)
      : this._(basemapStyle: basemapStyle);

  const ArcGISMap.fromPortalItem(PortalItem item) : this._(item: item);

  const ArcGISMap.fromSpatialReference(SpatialReference spatialReference)
      : this._(spatialReference: spatialReference);

  const ArcGISMap.fromUri(String uri) : this._(uri: uri);

  ArcGISMap.offlineMap(String path, {int mapIndex = 0})
      : this._(offlineInfo: ArcGISMapOfflineInfo._(path, mapIndex));

  final Basemap? basemap;

  final BasemapStyle? basemapStyle;

  final PortalItem? item;

  final SpatialReference? spatialReference;

  final String? uri;

  final ArcGISMapOfflineInfo? offlineInfo;

  Object toJson() {
    if (basemap != null) {
      return {
        'basemap': basemap!.toJson(),
      };
    }
    if (basemapStyle != null) {
      return {
        'basemapStyle': basemapStyle!.value,
      };
    }

    if (item != null) {
      return {
        'item': item!.toJson(),
      };
    }

    if (spatialReference != null) {
      return {
        'spatialReference': spatialReference!.toJson(),
      };
    }

    if (uri != null) {
      return {
        'uri': uri,
      };
    }

    if (offlineInfo != null) {
      return {
        'offlineInfo': offlineInfo!.toJson(),
      };
    }

    throw Exception('Invalid map');
  }

  @override
  List<Object?> get props => [
        basemap,
        basemapStyle,
        item,
        spatialReference,
        uri,
        offlineInfo,
      ];
}
