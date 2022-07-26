import 'dart:async';

import 'package:arcgis_maps_flutter/src/method_channel/native/arcgis_native_flutter_platform.dart';
import 'package:arcgis_maps_flutter/src/method_channel/native/native_message.dart';
import 'package:flutter/foundation.dart';

int _nativeObjectId = 0;

String _getNextId() {
  return '${_nativeObjectId++}';
}

abstract class ArcgisNativeObject {
  final String _id;
  StreamSubscription? _messageSubscription;
  bool _isDisposed = false;
  bool _isCreated = false;

  ArcgisNativeObject({String? objectId, bool isCreated = false})
      : _id = objectId ?? _getNextId(),
        _isCreated = isCreated {
    _messageSubscription = ArcgisNativeFlutterPlatform.instance.onMessage
        .where((event) => event.objectId == _id)
        .listen(_methodCallHandler);
  }

  @protected
  String get type;

  @mustCallSuper
  void dispose() {
    if (_isDisposed) {
      return;
    }
    _isDisposed = true;
    _messageSubscription?.cancel();
    _messageSubscription = null;
    if (_isCreated) {
      ArcgisNativeFlutterPlatform.instance.destroyNativeObject(objectId: _id);
    }
  }

  @optionalTypeArgs
  @protected
  Future<T?> invokeMethod<T>(String method, [dynamic arguments]) async {
    if (_isDisposed) {
      return null;
    }
    if (!_isCreated) {
      await ArcgisNativeFlutterPlatform.instance.createNativeObject(
        objectId: _id,
        type: type,
        arguments: getCreateArguments(),
      );
      _isCreated = true;
    }
    return await ArcgisNativeFlutterPlatform.instance.sendMessage(
      objectId: _id,
      method: method,
      arguments: arguments,
    );
  }

  @protected
  @mustCallSuper
  Future<void> handleMethodCall(String method, dynamic arguments) async {}

  void _methodCallHandler(NativeMessage message) async {
    if (_isDisposed) {
      return;
    }
    await handleMethodCall(message.method, message.arguments);
  }

  @protected
  dynamic getCreateArguments() => null;
}
