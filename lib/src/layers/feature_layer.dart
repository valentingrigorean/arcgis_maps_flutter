part of '../../arcgis_maps_flutter.dart';

@immutable
class FeatureLayer extends BaseTileLayer {
  FeatureLayer.fromUrl(
    String url, {
    LayerId? layerId,
    super.isVisible,
    super.opacity,
    this.renderer,
    this.definitionExpression,
    this.refreshInterval,
  })  : portalItemLayerId = -1,
        super.fromUrl(
          layerId: layerId ?? LayerId(url),
          url: url,
          type: 'FeatureLayer',
        );

  const FeatureLayer.fromPortalItem({
    required super.layerId,
    required super.portalItem,
    required this.portalItemLayerId,
    super.isVisible,
    super.opacity,
    this.renderer,
    this.definitionExpression,
    this.refreshInterval,
  }) : super.fromPortalItem(
          type: 'FeatureLayer',
        );

  final int portalItemLayerId;

  final Renderer? renderer;

  final String? definitionExpression;

  /// The objects refresh interval. The refresh interval, in milliseconds. A refresh interval of null means never refresh.
  final int? refreshInterval;

  @override
  List<Object?> get props => super.props
    ..addAll([
      portalItemLayerId,
      renderer,
      definitionExpression,
      refreshInterval,
    ]);

  @override
  clone() {
    return copyWith();
  }

  @override
  Map<String, Object> toJson() {
    var json = super.toJson();
    if (portalItem != null) {
      json['portalItemLayerId'] = portalItemLayerId;
    }
    json.addIfNonNull('definitionExpression', definitionExpression);
    json.addIfNonNull('refreshInterval', refreshInterval);
    json.addIfNonNull('renderer', renderer?.toJson());
    return json;
  }

  FeatureLayer copyWith({
    bool? isVisibleParam,
    double? opacityParam,
    Renderer? rendererParam,
    String? definitionExpressionParam,
    int? refreshIntervalParam,
  }) {
    if (url != null) {
      return FeatureLayer.fromUrl(
        url!,
        layerId: layerId,
        isVisible: isVisibleParam ?? isVisible,
        opacity: opacityParam ?? opacity,
        renderer: rendererParam ?? renderer,
        definitionExpression: definitionExpressionParam ?? definitionExpression,
        refreshInterval: refreshIntervalParam ?? refreshInterval,
      );
    }

    return FeatureLayer.fromPortalItem(
      layerId: layerId,
      portalItem: portalItem!,
      isVisible: isVisibleParam ?? isVisible,
      opacity: opacityParam ?? opacity,
      portalItemLayerId: portalItemLayerId,
      renderer: rendererParam ?? renderer,
      definitionExpression: definitionExpressionParam ?? definitionExpression,
    );
  }
}
