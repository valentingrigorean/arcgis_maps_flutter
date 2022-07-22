import 'package:flutter/foundation.dart' show immutable, objectRuntimeType;

/// Uniquely identifies object an among [GoogleMap] collections of a specific
/// type.
///
/// This does not have to be globally unique, only unique among the collection.
@immutable
class MapsObjectId<T> {
  /// Creates an immutable object representing a [T] among [GoogleMap] Ts.
  ///
  /// An [AssertionError] will be thrown if [value] is null.
  const MapsObjectId(this.value);

  /// The value of the id.
  final String value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    // ignore: test_types_in_equals
    final MapsObjectId<T> typedOther = other as MapsObjectId<T>;
    return value == typedOther.value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return '${objectRuntimeType(this, 'MapsObjectId')}($value)';
  }
}

/// A common interface for maps types.
abstract class MapsObject<T> {
  const MapsObject();

  /// A identifier for this object.
  MapsObjectId<T> get mapsId;

  /// Returns a duplicate of this object.
  T clone();

  /// Converts this object to something serializable in JSON.
  Object toJson();
}
