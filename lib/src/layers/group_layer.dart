part of arcgis_maps_flutter;

enum GroupVisibilityMode {
  /// Each child manages its visibility independent of the parent group.
  independent(0),

  /// Each child inherits the visibility of its parent group.
  inherited(1),

  /// Only one child is visible at a time.
  exclusive(2),
  ;

  const GroupVisibilityMode(this.value);

  factory GroupVisibilityMode.fromValue(int value) {
    return GroupVisibilityMode.values.firstWhere((e) => e.value == value);
  }

  final int value;
}

@immutable
class GroupLayer extends Layer {
  const GroupLayer({
    required LayerId layerId,
    required this.layers,
    this.showChildrenInLegend = true,
    this.visibilityMode = GroupVisibilityMode.independent,
    bool isVisible = true,
    double opacity = 1.0,
  }) : super(
          layerId: layerId,
          isVisible: isVisible,
          opacity: opacity,
        );

  final Set<Layer> layers;

  final GroupVisibilityMode visibilityMode;

  final bool showChildrenInLegend;

  @override
  Layer clone() {
    return GroupLayer(
      layerId: layerId,
      layers: layers,
      showChildrenInLegend: showChildrenInLegend,
      visibilityMode: visibilityMode,
      isVisible: isVisible,
      opacity: opacity,
    );
  }

  @override
  Map<String, Object> toJson() {
    var json = super.toJson();
    json["layerType"] = 'GroupLayer';
    json['visibilityMode'] = visibilityMode.value;
    json['showChildrenInLegend'] = showChildrenInLegend;
    json['layers'] = layers.map((e) => e.toJson()).toList();
    return json;
  }

  @override
  List<Object?> get props => [
        layers,
        visibilityMode,
        showChildrenInLegend,
      ];
}
