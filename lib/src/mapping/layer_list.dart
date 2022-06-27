part of arcgis_maps_flutter;

class LayerList {
  final List<Layer> _layers = [];
  final List<Function> _onListChangedListeners = [];

  int get length => _layers.length;

  Layer operator [](int index) => _layers[index];

  void operator []=(int index, Layer value) {
    _layers[index] = value;
    _notifyListChanged();
  }

  void dispose() {
    _onListChangedListeners.clear();
  }

  void add(Layer layer) {
    _layers.add(layer);
    _notifyListChanged();
  }

  void addAll(List<Layer> layers) {
    _layers.addAll(layers);
    _notifyListChanged();
  }

  void insert(int index, Layer layer) {
    _layers.insert(index, layer);
    _notifyListChanged();
  }

  void insertAll(int index, List<Layer> layers) {
    _layers.insertAll(index, layers);
    _notifyListChanged();
  }

  void clear() {
    _layers.clear();
    _notifyListChanged();
  }

  void remove(Layer layer) {
    if (_layers.remove(layer)) {
      _notifyListChanged();
    }
  }

  void removeAt(int index) {
    final layer = _layers[index];
    remove(layer);
  }

  void addOnListChangedListener(Function listener) {
    _onListChangedListeners.add(listener);
  }

  void removeOnListChangedListener(Function listener) {
    _onListChangedListeners.remove(listener);
  }

  void _notifyListChanged() {
    for (final listener in _onListChangedListeners.toList(growable: false)) {
      listener();
    }
  }
}
