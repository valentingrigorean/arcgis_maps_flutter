part of arcgis_maps_flutter;

@immutable
class Basemap extends Equatable {
  const Basemap._({
    this.basemapStyle,
    this.item,
    this.baseLayer,
    this.baseLayers,
    this.referenceLayers,
    this.uri,
  });

  const Basemap.fromStyle({
    required BasemapStyle basemapStyle,
  }) : this._(
          basemapStyle: basemapStyle,
        );

  const Basemap.fromItem({
    required PortalItem item,
  }) : this._(
          item: item,
        );

  const Basemap.fromBaseLayers({
    required Set<Layer> baseLayers,
    required Set<Layer> referenceLayers,
  }) : this._(
          baseLayers: baseLayers,
          referenceLayers: referenceLayers,
        );

  const Basemap.fromBaseLayer(Layer layer)
      : this._(
          baseLayer: layer,
        );

  const Basemap.fromUri(String uri)
      : this._(
          uri: uri,
        );

  final BasemapStyle? basemapStyle;
  final PortalItem? item;
  final Layer? baseLayer;
  final Set<Layer>? baseLayers;
  final Set<Layer>? referenceLayers;
  final String? uri;

  Object toJson() {
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

    if (baseLayer != null) {
      return {
        'baseLayer': baseLayer!.toJson(),
      };
    }

    if (baseLayers != null && referenceLayers != null) {
      return {
        'baseLayers': baseLayers!.map((e) => e.toJson()).toList(),
        'referenceLayers': referenceLayers!.map((e) => e.toJson()).toList(),
      };
    }

    if (uri != null) {
      return {
        'uri': uri,
      };
    }
    throw Exception('Basemap is not valid');
  }

  @override
  List<Object?> get props => [
        basemapStyle,
        item,
        baseLayer,
        baseLayers,
        referenceLayers,
        uri,
      ];
}
