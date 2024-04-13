part of '../../arcgis_maps_flutter.dart';

class PictureMarkerSymbol extends MarkerSymbol {


  const PictureMarkerSymbol.fromUrl({
    required String this.url,
    this.height,
    this.width,
    super.angle,
    super.angleAlignment,
    super.leaderOffset,
    super.offset,
  })  : resource = null,
        tintColor = null,
        imageData = null;

  const PictureMarkerSymbol.fromResource({
    required String this.resource,
    this.tintColor,
    this.height,
    this.width,
    super.angle,
    super.angleAlignment,
    super.leaderOffset,
    super.offset,
  })  : url = null,
        imageData = null;

  const PictureMarkerSymbol.fromImageData({
    required Uint8List this.imageData,
    super.angle,
    super.angleAlignment,
    super.leaderOffset,
    super.offset,
  })  : url = null,
        resource = null,
        tintColor = null,
        width = null,
        height = null;


  final String? url;

  final String? resource;

  final Color? tintColor;

  final Uint8List? imageData;

  final double? height;
  final double? width;


  @override
  String get type => 'picture-marker';

  @override
  List<Object?> get props => [
    ...super.props,
    url,
    resource,
    tintColor,
    height,
    width,
  ];

  @override
  Map<String, Object?> toJson() {
    final Map<String, Object?> json = super.toJson();
    json.addIfNonNull('url', url);
    json.addIfNonNull('resource', resource);
    json.addIfNonNull('tintColor', tintColor?.value);
    json.addIfNonNull('imageData', imageData);
    json.addIfNonNull('height', height);
    json.addIfNonNull('width', width);
    return json;
  }


}
