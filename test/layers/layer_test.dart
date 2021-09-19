import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

class LayerMock extends Layer {
  const LayerMock({
    required bool isVisible,
    required double opacity,
    required LayerId layerId,
  }) : super(
          isVisible: isVisible,
          opacity: opacity,
          layerId: layerId,
        );

  @override
  Layer clone() {
    throw UnimplementedError();
  }
}

void main() {
  test('Ctor', () {
    const layer = LayerMock(
      isVisible: true,
      opacity: 1,
      layerId: LayerId('layerId'),
    );

    expect(layer.opacity, 1.0);
    expect(layer.isVisible, true);
    expect(layer.layerId, const LayerId('layerId'));
  });

  test('toJson', () {
    const layer = LayerMock(
      isVisible: true,
      opacity: 1,
      layerId: LayerId('layerId'),
    );

     final json = layer.toJson();
    expect(json['opacity'], 1.0);
    expect(json['isVisible'], true);
    expect(json['layerId'],'layerId');
  });
}
