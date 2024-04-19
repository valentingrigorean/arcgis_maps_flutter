part of '../../arcgis_maps_flutter.dart';

@immutable
class FeatureLayer extends BaseTileLayer {
  FeatureLayer.fromUrl(String url, {
    LayerId? layerId,
    super.isVisible,
    super.opacity,
    this.refreshInterval,
    this.renderer,
    this.definitionExpression,
    this.enableLabels,
    this.labelDefinitions = const [],
  })
      : portalItemLayerId = -1,
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
    this.refreshInterval,
    this.renderer,
    this.definitionExpression,
    this.enableLabels,
    this.labelDefinitions = const [],
  }) : super.fromPortalItem(
    type: 'FeatureLayer',
  );

  final int portalItemLayerId;


  /// The objects refresh interval. The refresh interval, in milliseconds. A refresh interval of null means never refresh.
  final int? refreshInterval;


  final Renderer? renderer;

  final String? definitionExpression;

  final bool? enableLabels;

  final List<LabelDefinition>? labelDefinitions;

  @override
  List<Object?> get props =>
      super.props
        ..addAll([
          portalItemLayerId,
          refreshInterval,
          renderer,
          definitionExpression,
          enableLabels,
          labelDefinitions,
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
    json.addIfNonNull('refreshInterval', refreshInterval);
    json.addIfNonNull('renderer', renderer?.toJson());
    json.addIfNonNull('definitionExpression', definitionExpression);
    json.addIfNonNull('enableLabels', enableLabels);
    json.addIfNonNull(
      'labelDefinitions',
      labelDefinitions?.map((e) => e.toJson()).toList(),
    );
    return json;
  }

  FeatureLayer copyWith({
    bool? isVisibleParam,
    double? opacityParam,
    int? refreshIntervalParam,
    Renderer? rendererParam,
    String? definitionExpressionParam,
    bool? enableLabelsParam,
    List<LabelDefinition>? labelDefinitionsParam,
  }) {
    if (url != null) {
      return FeatureLayer.fromUrl(
        url!,
        layerId: layerId,
        isVisible: isVisibleParam ?? isVisible,
        opacity: opacityParam ?? opacity,
        refreshInterval: refreshIntervalParam ?? refreshInterval,
        renderer: rendererParam ?? renderer,
        definitionExpression: definitionExpressionParam ?? definitionExpression,
        enableLabels: enableLabelsParam ?? enableLabels,
        labelDefinitions: labelDefinitionsParam ?? labelDefinitions,
      );
    }

    return FeatureLayer.fromPortalItem(
      layerId: layerId,
      portalItem: portalItem!,
      isVisible: isVisibleParam ?? isVisible,
      opacity: opacityParam ?? opacity,
      portalItemLayerId: portalItemLayerId,
      refreshInterval: refreshIntervalParam ?? refreshInterval,
      renderer: rendererParam ?? renderer,
      definitionExpression: definitionExpressionParam ?? definitionExpression,
      enableLabels: enableLabelsParam ?? enableLabels,
      labelDefinitions: labelDefinitionsParam ?? labelDefinitions,
    );
  }
}
