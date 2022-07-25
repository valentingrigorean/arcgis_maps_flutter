import 'dart:async';
import 'package:arcgis_maps_flutter/src/method_channel/native/arcgis_native_flutter_platform.dart';
import 'package:arcgis_maps_flutter/src/method_channel/native/native_message.dart';
import 'package:flutter/services.dart';

class MethodChannelArcgisNativeFlutter extends ArcgisNativeFlutterPlatform {
  final MethodChannel _channel =
      const MethodChannel('plugins.flutter.io/arcgis_channel/native_objects');

  final StreamController<NativeMessage> _onMessage =
      StreamController<NativeMessage>.broadcast();

  MethodChannelArcgisNativeFlutter() {
    _channel.setMethodCallHandler(_methodCallHandler);
  }

  @override
  Stream<NativeMessage> get onMessage => _onMessage.stream;

  @override
  Future<void> createNativeObject({
    required int objectId,
    required String type,
    Map<String, dynamic>? data,
  }) async {
    await _channel.invokeMethod('createNativeObject', {
      'objectId': objectId,
      'type': type,
      'data': data,
    });
  }

  @override
  Future<void> destroyNativeObject({required int objectId}) async {
    await _channel.invokeMethod('destroyNativeObject', {
      'objectId': objectId,
    });
  }

  @override
  Future<T?> sendMessage<T>({
    required int objectId,
    required String method,
    dynamic arguments,
  }) async {
    final result = await _channel.invokeMethod<T>('sendMessage', {
      'objectId': objectId,
      'method': method,
      'arguments': arguments,
    });
    return result;
  }

  Future<dynamic> _methodCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'messageNativeObject':
        final NativeMessage message = NativeMessage.fromJson(call.arguments);
        _onMessage.add(message);
        break;
      default:
        throw UnimplementedError('Unknown method ${call.method}');
    }
  }
}
