part of arcgis_maps_flutter;

@immutable
class SuggestResult {
  const SuggestResult._(this.label, this.isCollection, this._suggestResultId);

  factory SuggestResult.fromJson(Map<dynamic, dynamic> json) {
    return SuggestResult._(
      json['label'] as String,
      json['isCollection'] as bool,
      json['suggestResultId'] as String,
    );
  }

  final String label;
  final bool isCollection;
  final String _suggestResultId;

  Object toJson() => _suggestResultId;

  @override
  String toString() {
    return 'SuggestResult{label: $label, isCollection: $isCollection';
  }
}
