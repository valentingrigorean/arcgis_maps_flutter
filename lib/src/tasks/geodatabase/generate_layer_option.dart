part of arcgis_maps_flutter;

enum GenerateLayerQueryOption {
  ///  An unknown query option. Normally the result when an error occurs.
  unknown(-1),

  /// All the features from the layer are included regardless of what is
  /// specified in [GenerateLayerOption.includeRelated],
  /// [GenerateLayerOption.whereClause], or [GenerateLayerOption.useGeometry].
  all(0),

  /// No features are included, unless they are related to a feature in another
  /// layer in the geodatabase and [GenerateLayerOption.includeRelated] is true.
  /// When combined with a sync direction of [GeodatabaseAttachmentSyncDirection.upload],
  /// this option can be used for an efficient upload-only work-flow.
  none(1),

  /// Only those features are included that satisfy filtering based
  /// on [GenerateLayerOption.whereClause] and optionally, the specified extent
  /// for the geodatabase ([GenerateGeodatabaseParameters.extent])
  /// if [GenerateLayerOption.useGeometry] is true.
  useFilter(2);

  const GenerateLayerQueryOption(this.value);

  factory GenerateLayerQueryOption.fromValue(int value) {
    return GenerateLayerQueryOption.values.firstWhere(
      (e) => e.value == value,
      orElse: () => GenerateLayerQueryOption.unknown,
    );
  }

  final int value;
}

class GenerateLayerOption {
  const GenerateLayerOption({
    required this.layerId,
    this.includeRelated = false,
    this.queryOption = GenerateLayerQueryOption.useFilter,
    this.useGeometry = true,
    this.whereClause = '',
  });

  factory GenerateLayerOption.fromJson(Map<dynamic, dynamic> json) {
    return GenerateLayerOption(
      layerId: json['layerId'] as int,
      includeRelated: json['includeRelated'] as bool,
      queryOption: GenerateLayerQueryOption.fromValue(json['queryOption'] as int),
      useGeometry: json['useGeometry'] as bool,
      whereClause: json['whereClause'] as String,
    );
  }

  /// Specifies whether to include any data from this layer that is related
  /// to data in other layers in the geodatabase.
  /// This parameters is only valid if the layer participates in
  /// any relationships, and if those related layers are also included in the geodatabase.
  /// Only applicable if the [queryOption] is [GenerateLayerQueryOption.none].
  final bool includeRelated;

  /// The ID of the layer for which these options are defined.
  /// Same as the @c AGSArcGISFeatureLayerInfo#serverLayerID property.
  final int layerId;

  /// Specifies how features should be included in the sync-enabled geodatabase.
  final GenerateLayerQueryOption queryOption;

  /// Determines whether to filter features based on geometry to include
  /// in the geodatabase. Only features that intersect the
  /// [GenerateGeodatabaseParameters.extent] property are considered
  /// for inclusion. Default value is true.
  /// Only applicable if [queryOption] is set to [GenerateLayerQueryOption.useFilter].
  /// See [whereClause] for additional filtering option.
  final bool useGeometry;

  /// An attribute query to filter which features should be included
  /// in the geodatabase. Can be empty, in which case features are not
  /// filtered based on the where clause.
  /// Only applicable if [queryOption] is set to [GenerateLayerQueryOption.useFilter].
  /// See [useGeometry] for additional filtering option.
  final String whereClause;

  GenerateLayerOption copyWith({
    int? layerId,
    bool? includeRelated,
    GenerateLayerQueryOption? queryOption,
    bool? useGeometry,
    String? whereClause,
  }) {
    return GenerateLayerOption(
      layerId: layerId ?? this.layerId,
      includeRelated: includeRelated ?? this.includeRelated,
      queryOption: queryOption ?? this.queryOption,
      useGeometry: useGeometry ?? this.useGeometry,
      whereClause: whereClause ?? this.whereClause,
    );
  }

  Object toJson(){
    return {
      'layerId': layerId,
      'includeRelated': includeRelated,
      'queryOption': queryOption.value,
      'useGeometry': useGeometry,
      'whereClause': whereClause,
    };
  }
}
