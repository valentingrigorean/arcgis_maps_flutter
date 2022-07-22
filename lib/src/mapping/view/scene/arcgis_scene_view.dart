part of arcgis_maps_flutter;

/// Callback method for when the map is ready to be used.
///
/// Pass to [ArcgisSceneView.onSceneCreated] to receive a [ArcgisSceneController] when the
/// map is created.
typedef SceneCreatedCallback = void Function(ArcgisSceneController controller);

// This counter is used to provide a stable "constant" initialization id
// to the buildView function, so the web implementation can use it as a
// cache key. This needs to be provided from the outside, because web
// views seem to re-render much more often that mobile platform views.
int _nextSceneCreationId = 0;

class ArcgisSceneView extends StatefulWidget {
  const ArcgisSceneView(
      {Key? key,
      required this.scene,
      required this.surface,
      required this.initialCamera,
      this.onSceneCreated})
      : super(key: key);

  /// Callback method for when the map is ready to be used.
  ///
  /// Used to receive a [ArcgisSceneController] for this [ArcgisSceneView].
  final SceneCreatedCallback? onSceneCreated;

  final ArcGISScene scene;

  final Camera initialCamera;

  final Surface surface;

  @override
  State<ArcgisSceneView> createState() => _ArcgisSceneViewState();
}

class _ArcgisSceneViewState extends State<ArcgisSceneView> {
  final _sceneId = _nextSceneCreationId++;

  final Completer<ArcgisSceneController> _controller =
      Completer<ArcgisSceneController>();

  late ArcGISScene _scene;
  late Surface _surface;

  @override
  void initState() {
    super.initState();
    _scene = widget.scene;
    _surface = widget.surface;
  }

  @override
  void didUpdateWidget(covariant ArcgisSceneView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateScene();
    _updateSurface();
  }

  @override
  Widget build(BuildContext context) {
    return ArcgisSceneFlutterPlatform.instance.buildView(
        _sceneId, onPlatformViewCreated,
        scene: widget.scene,
        surface: widget.surface,
        initialCamera: widget.initialCamera);
  }

  Future<void> onPlatformViewCreated(int id) async {
    final ArcgisSceneController controller =
        await ArcgisSceneController.init(id, this);

    _controller.complete(controller);

    final SceneCreatedCallback? onMapCreated = widget.onSceneCreated;
    if (onMapCreated != null) {
      onMapCreated(controller);
    }
  }

  void _updateScene() async {
    if (widget.scene == _scene) {
      return;
    }
    final ArcgisSceneController controller = await _controller.future;
    controller.setScene(widget.scene);
    _scene = widget.scene;
  }

  void _updateSurface() async {
    if (widget.surface == _surface) {
      return;
    }
    final ArcgisSceneController controller = await _controller.future;
    controller.setSurface(widget.surface);
    _surface = widget.surface;
  }
}
