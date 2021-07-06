part of arcgis_maps_flutter;

class MarkerId extends SymbolId<Marker> {
  MarkerId(String value) : super(value);
}

class Marker extends Symbol {
  Marker({
    required MarkerId markerId,
    required this.position,
    required this.icon,
    this.consumeTapEvents = false,
    this.iconOffsetX = 0,
    this.iconOffsetY = 0,
    this.backgroundImage,
    this.opacity = 1,
    this.onTap,
    this.visible = true,
    this.zIndex = 0,
    this.selectedColor,
    this.selectedScale = 1.4,
  })  : assert(opacity >= 0 && opacity <= 1),
        markerId = markerId,
        super(symbolId: markerId);

  /// Uniquely identifies a [Marker].
  final MarkerId markerId;

  final Point position;

  final BitmapDescriptor icon;

  final double iconOffsetX;

  final double iconOffsetY;

  final BitmapDescriptor? backgroundImage;

  /// The opacity of the marker, between 0.0 and 1.0 inclusive.
  ///
  /// 0.0 means fully transparent, 1.0 means fully opaque.
  final double opacity;

  /// True if the marker icon consumes tap events. If not, the map will perform
  /// default tap handling by centering the map on the marker and displaying its
  /// info window.
  final bool consumeTapEvents;

  final VoidCallback? onTap;

  final int zIndex;

  /// True if the marker is visible.
  final bool visible;

  final Color? selectedColor;

  final double selectedScale;

  @override
  clone() {
    return Marker(
      markerId: markerId,
      position: position,
      icon: icon,
      iconOffsetX: iconOffsetX,
      iconOffsetY: iconOffsetY,
      backgroundImage: backgroundImage,
      consumeTapEvents: consumeTapEvents,
      opacity: opacity,
      onTap: onTap,
      visible: visible,
      zIndex: zIndex,
      selectedColor: selectedColor,
    );
  }

  @override
  Object toJson() {
    final Map<String, Object> json = <String, Object>{};

    json['markerId'] = markerId.value;
    json['visible'] = visible;
    json['consumeTapEvents'] = consumeTapEvents;
    json['position'] = position.toJson();
    json['icon'] = icon.toJson();
    json['iconOffsetX'] = iconOffsetX;
    json['iconOffsetY'] = iconOffsetY;

    if (backgroundImage != null) {
      json['backgroundImage'] = backgroundImage!.toJson();
    }

    if (selectedColor != null) {
      json['selectedColor'] = selectedColor!.value;
    }

    json['opacity'] = opacity;
    json['selectedScale'] = selectedScale;
    json['zIndex'] = zIndex;
    return json;
  }

  @override
  int get hashCode => markerId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Marker &&
          runtimeType == other.runtimeType &&
          markerId == other.markerId &&
          position == other.position &&
          icon == other.icon &&
          iconOffsetX == other.iconOffsetX &&
          iconOffsetY == other.iconOffsetY &&
          backgroundImage == other.backgroundImage &&
          opacity == other.opacity &&
          consumeTapEvents == other.consumeTapEvents &&
          zIndex == other.zIndex &&
          visible == other.visible &&
          selectedColor == other.selectedColor;
}
