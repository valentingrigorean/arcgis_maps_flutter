part of arcgis_maps_flutter;

enum FontStyle {
  italic,
  normal,
  oblique,
}

enum FontWeight {
  normal,
  bold,
}

enum HorizontalAlignment {
  center,
  justify,
  left,
  right,
}

enum VerticalAlignment {
  baseline,
  bottom,
  middle,
  top,
}

class TextSymbol extends MarkerSymbol {
  final String text;
  final Color? color;

  final String? fontFamily;
  final FontStyle? fontStyle;

  final FontWeight? fontWeight;

  final Color? haloColor;

  final double? haloWidth;

  final HorizontalAlignment? horizontalAlignment;

  final bool? kerning;

  final Color? outlineColor;

  final double? size;

  final VerticalAlignment? verticalAlignment;

  const TextSymbol({
    required this.text,
    this.color,
    this.fontFamily,
    this.fontStyle,
    this.fontWeight,
    this.haloColor,
    this.haloWidth,
    this.horizontalAlignment,
    this.kerning,
    this.outlineColor,
    this.size,
    this.verticalAlignment,
    super.angle,
    super.angleAlignment,
    super.leaderOffset,
    super.offset,
  });

  @override
  Map<String, Object?> toJson() {
    final Map<String, Object?> json = super.toJson();
    json['text'] = text;
    if (color != null) {
      json['color'] = color!.value;
    }
    if (size != null) {
      json['size'] = size;
    }
    if (fontFamily != null) {
      json['fontFamily'] = fontFamily;
    }
    VerticalAlignment.top;
    if (fontStyle != null) {
      json['fontStyle'] = fontStyle!.name;
    }
    if (fontWeight != null) {
      json['fontWeight'] = fontWeight!.name;
    }
    if (haloColor != null) {
      json['haloColor'] = haloColor!.value;
    }
    if (haloWidth != null) {
      json['haloWidth'] = haloWidth;
    }

    if (kerning != null) {
      json['kerning'] = kerning;
    }
    if (outlineColor != null) {
      json['outlineColor'] = outlineColor!.value;
    }
    if (horizontalAlignment != null) {
      json['horizontalAlignment'] = horizontalAlignment!.name;
    }
    if (verticalAlignment != null) {
      json['verticalAlignment'] = verticalAlignment!.name;
    }
    return json;
  }

  @override
  List<Object?> get props => [
        ...super.props,
        text,
        color,
        fontFamily,
        fontStyle,
        fontWeight,
        haloColor,
        haloWidth,
        horizontalAlignment,
        kerning,
        outlineColor,
        size,
        verticalAlignment,
      ];
}
