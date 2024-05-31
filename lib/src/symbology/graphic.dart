part of '../../arcgis_maps_flutter.dart';

final class GraphicId extends MapsObjectId<Graphic> {
  const GraphicId(super.value);
}

class Graphic implements MapsObject {
  const Graphic({
    required this.id,
    this.consumeTapEvents = false,
    this.onTap,
    this.symbol,
    this.geometry,
    this.selectedColor,
    this.isSelected = false,
    this.zIndex = 0,
  });

  final GraphicId id;

  /// True if the marker icon consumes tap events.
  final bool consumeTapEvents;

  final VoidCallback? onTap;

  final bool isSelected;

  final GraphicSymbol? symbol;
  final Geometry? geometry;

  final int zIndex;

  final Color? selectedColor;

  @override
  clone() {
    return Graphic(
      id: id,
      consumeTapEvents: consumeTapEvents,
      onTap: onTap,
      symbol: symbol,
      geometry: geometry,
      selectedColor: selectedColor,
      isSelected: isSelected,
      zIndex: zIndex,
    );
  }

  @override
  MapsObjectId get mapsId => id;

  @override
  Object toJson() {
    final Map<String, Object?> json = {
      'graphicId': id.value,
      'consumeTapEvents': consumeTapEvents,
      'isSelected': isSelected,
      'zIndex': zIndex,
    };

    if (symbol != null) {
      json['symbol'] = symbol!.toJson();
    }

    if (geometry != null) {
      json['geometry'] = geometry!.toJson();
    }

    if (selectedColor != null) {
      json['selectedColor'] = selectedColor!.value;
    }

    return json;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Graphic &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          consumeTapEvents == other.consumeTapEvents &&
          isSelected == other.isSelected &&
          zIndex == other.zIndex &&
          selectedColor == other.selectedColor &&
          symbol == other.symbol &&
          geometry == other.geometry;

  @override
  String toString() {
    return 'Graphic{id: $id, consumeTapEvents: $consumeTapEvents, isSelected: $isSelected, zIndex: $zIndex, selectedColor: $selectedColor, symbol: ${symbol?.runtimeType}, geometry: ${geometry?.runtimeType}}';
  }
}
