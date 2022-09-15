part of arcgis_maps_flutter;

enum EditOperation {
  add(0),
  update(1),
  delete(2),
  unknown(-1);

  const EditOperation(this.value);

  factory EditOperation.fromValue(int value) {
    return EditOperation.values.firstWhere(
      (e) => e.value == value,
      orElse: () => EditOperation.unknown,
    );
  }

  final int value;
}

class EditResult {
  const EditResult({
    required this.completedWithErrors,
    required this.editOperation,
    required this.error,
    required this.globalId,
    required this.objectId,
    this.attachmentResults = const [],
  });

  factory EditResult.fromJson(Map<dynamic, dynamic> json) {
    return EditResult(
      completedWithErrors: json['completedWithErrors'] as bool,
      editOperation: EditOperation.fromValue(json['editOperation'] as int),
      error: ArcgisError.fromJson(json['error']),
      globalId: json['globalId'] as String,
      objectId: json['objectId'] as int,
      attachmentResults: (json['attachmentResults'] as List<dynamic>?)
              ?.map((e) => EditResult.fromJson(e as Map<dynamic, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Indicates if the edit operation encountered an error
  final bool completedWithErrors;

  /// The type of edit performed
  final EditOperation editOperation;

  /// The error encountered during the edit operation. Only available if [completedWithErrors] is true.
  final ArcgisError? error;

  /// The Globl ID of the entity (feature or attachment) being edited
  final String globalId;

  /// he Object ID of the entity (feature or attachment) being edited
  final int objectId;

  /// Results of edit operations on attachments belonging to this feature.
  final List<EditResult> attachmentResults;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditResult &&
          runtimeType == other.runtimeType &&
          completedWithErrors == other.completedWithErrors &&
          editOperation == other.editOperation &&
          error == other.error &&
          globalId == other.globalId &&
          objectId == other.objectId &&
          attachmentResults == other.attachmentResults;

  @override
  int get hashCode =>
      completedWithErrors.hashCode ^
      editOperation.hashCode ^
      error.hashCode ^
      globalId.hashCode ^
      objectId.hashCode ^
      attachmentResults.hashCode;

  @override
  String toString() {
    return 'EditResult{completedWithErrors: $completedWithErrors, editOperation: $editOperation, error: $error, globalId: $globalId, objectId: $objectId, attachmentResults: $attachmentResults}';
  }
}
