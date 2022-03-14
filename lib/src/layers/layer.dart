part of arcgis_maps_flutter;

@immutable
class LayerId extends MapsObjectId<Layer> {
  const LayerId(String value) : super(value);
}

abstract class Layer extends MapsObject<Layer> with EquatableMixin {
  const Layer({
    required this.isVisible,
    required this.opacity,
    required this.layerId,
  }) : assert(opacity >= 0 && opacity <= 1.0);

  @override
  LayerId get mapsId => layerId;

  final bool isVisible;
  final double opacity;
  final LayerId layerId;

  @override
  Map<String, Object> toJson() {
    return {
      'isVisible': isVisible,
      'opacity': opacity,
      'layerId': layerId.value,
    };
  }

  @override
  bool? get stringify => true;

  @override
  // ignore: hash_and_equals
  int get hashCode => layerId.hashCode;

  @override
  List<Object?> get props => [
        isVisible,
        opacity,
        layerId,
      ];
}
