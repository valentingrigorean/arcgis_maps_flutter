part of arcgis_maps_flutter;

class DisposeScope {
  final List<ArcgisNativeObject> _objects = [];
  bool _isDisposed = false;

  void add(ArcgisNativeObject object) {
    _checkIfDisposed();
    _objects.add(object);
  }

  void addAll(Iterable<ArcgisNativeObject> objects) {
    _checkIfDisposed();
    _objects.addAll(objects);
  }

  void dispose() {
    if (_isDisposed) {
      return;
    }
    _isDisposed = true;
    for (ArcgisNativeObject object in _objects) {
      object.dispose();
    }
  }

  void _checkIfDisposed() {
    if (_isDisposed) {
      throw Exception('This object has been disposed.');
    }
  }
}

extension DisposeScopeExtension<T extends ArcgisNativeObject> on T {
  T disposeWith(DisposeScope scope) {
    scope.add(this);
    return this;
  }
}
