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

/// took from https://github.com/Esri/arcgis-runtime-toolkit-android/blob/master/arcgis-android-toolkit/src/main/java/com/esri/arcgisruntime/toolkit/scalebar/Constants.kt
const Color _kDefaultFillColor = Color(0x80d3d3d3);
const Color _kDefaultAlternateFillColor = Colors.black;
const Color _kDefaultLineColor = Colors.white;
const Color _kDefaultShadowColor = Color(0x80000000);
const Color _kDefaultTextColor = Colors.black;
const Color _kDefaultTextShadowColor = Colors.white;

@immutable
class ScalebarConfiguration {
  const ScalebarConfiguration({
    this.width = 150,
    this.height = 50,

    /// If [showInMap] it's false will use the offset from top-left
    this.offset = const Offset(16, 16),

    /// If [showInMap] it's true will use  [inMapAlignment] to position the
    /// scalebar at bottom of the map
    this.showInMap = true,
    this.inMapAlignment = ScalebarAlignment.left,
    this.autoHide = false,
    this.hideAfter = const Duration(seconds: 2),
    this.units = ScalebarUnits.imperial,
    this.style = ScalebarStyle.line,
    this.fillColor = _kDefaultFillColor,
    this.alternateFillColor = _kDefaultAlternateFillColor,
    this.lineColor = _kDefaultLineColor,
    this.shadowColor = _kDefaultShadowColor,
    this.textColor = _kDefaultTextColor,
    this.textShadowColor = _kDefaultTextShadowColor,
  });

  final int width;
  final int height;

  final Offset offset;

  /// The app has limited control over the position of the scalebar (bottom-left,
  /// bottom-right or bottom-centered) and no control over the size (it is sized automatically to fit comfortably within
  /// the MapView
  final bool showInMap;

  /// Used to align scalebar if [showInMap] true.
  final ScalebarAlignment inMapAlignment;

  final bool autoHide;

  final Duration hideAfter;

  final ScalebarUnits units;

  final ScalebarStyle style;

  /// Defaults to [Colors.grey]
  final Color fillColor;

  /// Defaults to [Colors.black]
  final Color alternateFillColor;

  /// Defaults to [Colors.white]
  final Color lineColor;

  /// Defaults to [Colors.black] with opacity 0.65
  final Color shadowColor;

  /// Defaults to [Colors.black]
  final Color textColor;

  /// Defaults to [Colors.white]
  final Color textShadowColor;

  ScalebarConfiguration copyWith({
    int? width,
    int? height,
    Offset? offset,
    bool? showInMap,
    ScalebarAlignment? inMapAlignment,
    bool? autoHide,
    ScalebarUnits? units,
    ScalebarStyle? style,
    Color? fillColor,
    Color? alternateFillColor,
    Color? lineColor,
    Color? shadowColor,
    Color? textColor,
    Color? textShadowColor,
  }) {
    return ScalebarConfiguration(
      width: width ?? this.width,
      height: height ?? this.height,
      offset: offset ?? this.offset,
      showInMap: showInMap ?? this.showInMap,
      inMapAlignment: inMapAlignment ?? this.inMapAlignment,
      autoHide: autoHide ?? this.autoHide,
      units: units ?? this.units,
      style: style ?? this.style,
      fillColor: fillColor ?? this.fillColor,
      alternateFillColor: alternateFillColor ?? this.alternateFillColor,
      lineColor: lineColor ?? this.lineColor,
      shadowColor: shadowColor ?? this.shadowColor,
      textColor: textColor ?? this.textColor,
      textShadowColor: textShadowColor ?? this.textShadowColor,
    );
  }

  Object toJson() {
    final Map<String, Object> json = <String, Object>{};
    json['showInMap'] = showInMap;
    if (!showInMap) {
      json['width'] = width;
      json['height'] = height;
      json['offset'] = [offset.dx, offset.dy];
    } else {
      json['inMapAlignment'] = inMapAlignment.index;
    }

    json['autoHide'] = autoHide;
    json['hideAfter'] = hideAfter.inMilliseconds;

    json['units'] = units.index;
    json['style'] = style.index;

    json['fillColor'] = fillColor.value;
    json['alternateFillColor'] = alternateFillColor.value;
    json['lineColor'] = lineColor.value;
    json['shadowColor'] = shadowColor.value;
    json['textColor'] = textColor.value;
    json['textShadowColor'] = textShadowColor.value;

    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScalebarConfiguration &&
          runtimeType == other.runtimeType &&
          width == other.width &&
          height == other.height &&
          offset == other.offset &&
          autoHide == other.autoHide &&
          hideAfter == other.hideAfter &&
          units == other.units &&
          style == other.style &&
          fillColor == other.fillColor &&
          alternateFillColor == other.alternateFillColor &&
          lineColor == other.lineColor &&
          shadowColor == other.shadowColor &&
          textColor == other.textColor &&
          textShadowColor == other.textShadowColor &&
          inMapAlignment == other.inMapAlignment &&
          showInMap == other.showInMap;

  @override
  int get hashCode =>
      width.hashCode ^
      height.hashCode ^
      offset.hashCode ^
      autoHide.hashCode ^
      hideAfter.hashCode ^
      units.hashCode ^
      style.hashCode ^
      fillColor.hashCode ^
      alternateFillColor.hashCode ^
      lineColor.hashCode ^
      shadowColor.hashCode ^
      textColor.hashCode ^
      textShadowColor.hashCode ^
      inMapAlignment.hashCode ^
      showInMap.hashCode;
}
