part of arcgis_maps_flutter;

@immutable
class WmsServiceInfo extends Equatable {
  const WmsServiceInfo({
    required this.name,
    required this.title,
    required this.serviceDescription,
    required this.version,
    required this.layersInfo,
    this.keywords = const [],
    required this.imageFormats,
  });

  /// Name of the service.
  final String name;

  /// Title of the service.
  final String title;

  /// A brief narrative description of the WMS service.
  final String serviceDescription;

  /// The version of the WMS service.
  /// Runtime supports WMS versions 1.3.0, 1.1.1, and 1.1.0.
  /// The latest supported WMS version is set as the default.
  /// To specify a preferred WMS version, set the  VERSION parameter
  /// in the [WmsService.url] for the service.
  final WmsVersion version;

  /// Layers available in the service.
  final List<WmsLayerInfo> layersInfo;

  /// An unordered list of commonly used words to describe this dataset.
  final List<String> keywords;

  /// The image formats [ImageFormat] supported by the WMS service.
  final List<ImageFormat> imageFormats;

  @override
  List<Object?> get props => [
        title,
        name,
        serviceDescription,
        version,
        layersInfo,
        keywords,
        imageFormats
      ];
}
