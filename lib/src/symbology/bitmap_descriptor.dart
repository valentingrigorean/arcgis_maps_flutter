part of arcgis_maps_flutter;

enum SimpleMarkerSymbolStyle {
  circle,
  cross,
  diamond,
  square,
  triangle,
  x,
}

@immutable
class BitmapDescriptor {
  final _BitmapDescriptorBase _bitmapDescriptorBase;

  const BitmapDescriptor._(this._bitmapDescriptorBase);

  static BitmapDescriptor fromNativeAsset(
    String name, {
    double width = -1,
    double height = -1,
    Color? tintColor,
  }) {
    return BitmapDescriptor._(
      _BitmapDescriptorNative(
        fileName: name,
        width: width,
        height: height,
        tintColor: tintColor,
      ),
    );
  }

  static BitmapDescriptor fromArray(List<BitmapDescriptor> descriptors) {
    return BitmapDescriptor._(_ListBitmapDescriptor(descriptors));
  }

  static BitmapDescriptor fromStyleMarker({
    required SimpleMarkerSymbolStyle style,
    required Color color,
    required double size,
  }) {
    return BitmapDescriptor._(
        _SimpleStyleMarkerBitmapDescriptor(style, color, size));
  }

  /// Creates a BitmapDescriptorFactory using an array of bytes that must be encoded
  /// as PNG.
  static BitmapDescriptor fromBytes(Uint8List byteData) {
    return BitmapDescriptor._(_BitmapDescriptorRaw(byteData: byteData));
  }

  static Future<BitmapDescriptor> fromWidget({
    required BuildContext context,
    required WidgetBuilder builder,
  }) async {
    final completer = Completer<BitmapDescriptor>();
    late final OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(builder: (context) {
      return _MarkerInfo(
        child: builder(context),
        onBitmapCreated: (bitmap) {
          overlayEntry.remove();
          completer.complete(fromBytes(bitmap));
        },
      );
    });

    final overlay = Overlay.of(context)!;

    overlay.insert(overlayEntry);

    return completer.future;
  }

  Object toJson() => _bitmapDescriptorBase.toJson();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BitmapDescriptor &&
          runtimeType == other.runtimeType &&
          _bitmapDescriptorBase == other._bitmapDescriptorBase;

  @override
  int get hashCode => _bitmapDescriptorBase.hashCode;
}

abstract class _BitmapDescriptorBase {
  Object toJson();
}

@immutable
class _BitmapDescriptorRaw implements _BitmapDescriptorBase {
  const _BitmapDescriptorRaw({required this.byteData});

  final Uint8List byteData;

  @override
  Object toJson() {
    final json = <String, Object>{};
    json['fromBytes'] = byteData;
    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _BitmapDescriptorRaw &&
          runtimeType == other.runtimeType &&
          byteData == other.byteData;

  @override
  int get hashCode => byteData.hashCode;
}

@immutable
class _BitmapDescriptorNative implements _BitmapDescriptorBase {
  const _BitmapDescriptorNative({
    required this.fileName,
    this.width = -1,
    this.height = 1,
    this.tintColor,
  });

  final String fileName;

  final double width;
  final double height;
  final Color? tintColor;

  @override
  Object toJson() {
    final json = <String, Object>{};
    json['fromNativeAsset'] = fileName;
    json['width'] = width;
    json['height'] = height;
    if (tintColor != null) {
      json['tintColor'] = tintColor!.value;
    }
    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _BitmapDescriptorNative &&
          runtimeType == other.runtimeType &&
          fileName == other.fileName &&
          width == other.width &&
          height == other.height &&
          tintColor == other.tintColor;

  @override
  int get hashCode =>
      fileName.hashCode ^ width.hashCode ^ height.hashCode ^ tintColor.hashCode;
}

@immutable
class _ListBitmapDescriptor implements _BitmapDescriptorBase {
  const _ListBitmapDescriptor(this.descriptors);

  final List<BitmapDescriptor> descriptors;

  @override
  Object toJson() {
    final json = <String, Object>{};
    json['descriptors'] = descriptors.map((e) => e.toJson()).toList();
    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ListBitmapDescriptor &&
          runtimeType == other.runtimeType &&
          listEquals(descriptors, other.descriptors);

  @override
  int get hashCode => hashList(descriptors);
}

@immutable
class _SimpleStyleMarkerBitmapDescriptor implements _BitmapDescriptorBase {
  const _SimpleStyleMarkerBitmapDescriptor(this.style, this.color, this.size);

  final SimpleMarkerSymbolStyle style;
  final Color color;
  final double size;

  @override
  Object toJson() {
    final json = <String, Object>{};
    json['styleMarker'] = style.index;
    json['color'] = color.value;
    json['size'] = size;
    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _SimpleStyleMarkerBitmapDescriptor &&
          runtimeType == other.runtimeType &&
          style == other.style &&
          size == other.size &&
          color == other.color;

  @override
  int get hashCode => style.hashCode ^ color.hashCode ^ size.hashCode;
}

class _MarkerInfo extends StatefulWidget {
  const _MarkerInfo({
    Key? key,
    required this.child,
    required this.onBitmapCreated,
  }) : super(key: key);

  final Widget child;

  final ValueChanged<Uint8List> onBitmapCreated;

  @override
  State<_MarkerInfo> createState() => _MarkerInfoState();
}

class _MarkerInfoState extends State<_MarkerInfo> {
  final _markerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getUint8List(_markerKey)
        .then((markerBitmap) => widget.onBitmapCreated(markerBitmap)));
  }

  Future<Uint8List> getUint8List(GlobalKey markerKey) async {
    RenderRepaintBoundary boundary =
        _markerKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(MediaQuery.of(context).size.width, 0),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RepaintBoundary(
              key: _markerKey,
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}
