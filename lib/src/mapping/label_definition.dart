part of '../../arcgis_maps_flutter.dart';

enum LabelingPlacement {
  automatic,
  lineAboveAfter,
  lineAboveAlong,
  lineAboveBefore,
  lineAboveEnd,
  lineAboveStart,
  lineBelowAfter,
  lineBelowAlong,
  lineBelowBefore,
  lineBelowEnd,
  lineBelowStart,
  lineCenterAfter,
  lineCenterAlong,
  lineCenterBefore,
  lineCenterEnd,
  lineCenterStart,
  pointAboveCenter,
  pointAboveLeft,
  pointAboveRight,
  pointBelowCenter,
  pointBelowLeft,
  pointBelowRight,
  pointCenterCenter,
  pointCenterLeft,
  pointCenterRight,
  polygonAlwaysHorizontal,
  unknown,
}

abstract class LabelExpression {
  const LabelExpression();

  String get type;

  Map<String, Object?> toJson() {
    final Map<String, Object?> json = <String, Object?>{};
    json['type'] = type;
    return json;
  }
}

class SimpleLabelExpression extends LabelExpression {
  const SimpleLabelExpression({
    required this.expression,
  });

  final String expression;

  @override
  String get type => 'simple';

  @override
  Map<String, Object?> toJson() {
    final Map<String, Object?> json = super.toJson();
    json['expression'] = expression;
    return json;
  }
}

class ArcadeLabelExpression extends LabelExpression {
  const ArcadeLabelExpression({
    required this.expression,
  });

  final String expression;

  @override
  String get type => 'arcade';

  @override
  Map<String, Object?> toJson() {
    final Map<String, Object?> json = super.toJson();
    json['expression'] = expression;
    return json;
  }
}

class LabelDefinition extends Equatable {
  const LabelDefinition({
    required this.labelExpression,
    this.placement = LabelingPlacement.automatic,
    this.symbol,
    this.minScale,
    this.maxScale,
  });

  final LabelExpression labelExpression;
  final TextSymbol? symbol;
  final LabelingPlacement placement;

  final double? minScale;
  final double? maxScale;

  @override
  List<Object?> get props => [labelExpression, symbol, minScale, maxScale];

  Map<String, Object?> toJson() {
    final Map<String, Object?> json = <String, Object?>{};
    json['labelExpression'] = labelExpression.toJson();
    json['placement'] = placement.name;
    json.addIfNonNull('symbol', symbol?.toJson());
    json.addIfNonNull('minScale', minScale);
    json.addIfNonNull('maxScale', maxScale);
    return json;
  }
}
