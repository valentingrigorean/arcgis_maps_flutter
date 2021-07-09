part of arcgis_maps_flutter;

enum ScalebarUnits {
  imperial,
  metric,
}

enum ScalebarStyle {
  line,
  bar,
  graduatedLine,
  alternatingBar,
  dualUnitLine,
}

enum ScalebarAlignment {
  left,
  right,
  center,
}

@immutable
class ScalebarConfiguration {
  const ScalebarConfiguration({
    this.units = ScalebarUnits.imperial,
    this.style = ScalebarStyle.line,
    this.fillColor,
    this.alternateFillColor,
    this.lineColor = Colors.white,
    this.shadowColor,
    this.textColor,
    this.textShadowColor,
    this.alignment = ScalebarAlignment.left,
    this.offset,
  });

  final ScalebarUnits units;

  final ScalebarStyle style;

  /// Defaults to [Colors.grey]
  final Color? fillColor;

  /// Defaults to [Colors.black]
  final Color? alternateFillColor;

  /// Defaults to [Colors.white]
  final Color lineColor;

  /// Defaults to [Colors.black] with opacity 0.65
  final Color? shadowColor;

  /// Defaults to [Colors.black]
  final Color? textColor;

  /// Defaults to [Colors.white]
  final Color? textShadowColor;

  final ScalebarAlignment alignment;

  final Offset? offset;

  Object toJson() {
    final Map<String, Object> json = <String, Object>{};
    json['units'] = units.index;
    json['style'] = style.index;
    if (fillColor != null) json['fillColor'] = fillColor!.value;
    if (alternateFillColor != null)
      json['alternateFillColor'] = alternateFillColor!.value;
    json['lineColor'] = lineColor.value;
    if (shadowColor != null) json['shadowColor'] = shadowColor!.value;
    if (textColor != null) json['textColor'] = textColor!.value;
    json['alignment'] = alignment.index;
    if (offset != null) json['offset'] = [offset!.dx, offset!.dy];
    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScalebarConfiguration &&
          runtimeType == other.runtimeType &&
          units == other.units &&
          style == other.style &&
          fillColor == other.fillColor &&
          alternateFillColor == other.alternateFillColor &&
          lineColor == other.lineColor &&
          shadowColor == other.shadowColor &&
          textColor == other.textColor &&
          textShadowColor == other.textShadowColor &&
          alignment == other.alignment &&
          offset == other.offset;

  @override
  int get hashCode =>
      units.hashCode ^
      style.hashCode ^
      fillColor.hashCode ^
      alternateFillColor.hashCode ^
      lineColor.hashCode ^
      shadowColor.hashCode ^
      textColor.hashCode ^
      textShadowColor.hashCode ^
      alignment.hashCode ^
      offset.hashCode;
}
