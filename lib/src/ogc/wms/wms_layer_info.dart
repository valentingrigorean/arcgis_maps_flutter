part of arcgis_maps_flutter;

@immutable
class WmsLayerInfo extends Equatable {
  const WmsLayerInfo({
    required this.title,
    required this.layerDescription,
    this.extent,
    this.fixedImageHeight = 0,
    this.fixedImageWidth = 0,
    this.keywords = const [],
    required this.name,
    this.isOpaque = false,
    this.isQueryable = false,
    required this.spatialReferences,
    this.styles = const [],
    this.sublayerInfos = const [],
    this.dimensions = const [],
  });

  /// Title of the layer. The title property is intended for use as
  /// a human-readable layer identification. The title is not unique.
  /// Note also that a layer with a title but no name describes a category
  /// for use as a container for sublayers.
  final String title;

  /// A brief narrative description of the layer.
  final String layerDescription;

  /// The geographic extent this layer covers
  final Envelope? extent;

  /// A value indicating the height (in points) of map images the service
  /// is capable of producing. When present and nonzero, it indicates that
  /// the server is not able to produce a map image at a height different
  /// from the fixed height indicated.
  final int fixedImageHeight;

  /// A value indicating the width (in points) of map images the service
  /// is capable of producing. When present and nonzero, it indicates that
  /// the server is not able to produce a map image at a width different
  /// from the fixed width indicated.
  final int fixedImageWidth;

  /// List of keywords describing the layer
  final List<String> keywords;

  /// Name of the layer. Layers may have a name and a [title].
  /// Only layers with a name are displayable.
  /// Layers with only a title are categories for other layers.
  /// Layers with a name may also have children; displaying these layers will
  /// display all sublayers.
  final String name;

  /// Indicates if the layer is opaque and obscures content of other
  /// layers below it. It describes the layer's data content, not the picture
  /// format of the map image. A true value indicates that the map data are
  /// mostly or completely opaque. A false value indicates that the map data
  /// represent vector features that probably do not completely fill space.
  /// In practice, a layer with opaque set to true is a good candidate for
  /// use as a basemap.
  final bool isOpaque;

  /// Indicates whether the layer is queryable or not.
  final bool isQueryable;

  /// The spatial reference of the layer
  final List<SpatialReference> spatialReferences;

  /// Available styles for the layer. Styles are server-defined options for
  /// how the layer and its information are displayed. Note that the order
  /// of styles returned does not indicate which style is the default.
  final List<String> styles;

  /// Sublayers of this layer.
  final List<WmsLayerInfo> sublayerInfos;

  final List<WmsLayerDimension> dimensions;

  @override
  List<Object?> get props => [
        title,
        layerDescription,
        extent,
        fixedImageHeight,
        fixedImageWidth,
        keywords,
        name,
        isOpaque,
        isQueryable,
        spatialReferences,
        styles,
        sublayerInfos,
        dimensions,
      ];
}
