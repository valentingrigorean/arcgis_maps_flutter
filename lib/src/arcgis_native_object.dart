import 'dart:async';

import 'package:arcgis_maps_flutter/src/method_channel/native/arcgis_native_flutter_platform.dart';
import 'package:arcgis_maps_flutter/src/method_channel/native/native_message.dart';
import 'package:flutter/foundation.dart';

int _nativeObjectId = 0;

String _getNextId() {
  return '${_nativeObjectId++}';
}

abstract class ArcgisNativeObject {
  final Completer<void> _onCreated = Completer<void>();
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

    if (_isCreated) {
      _onCreated.complete();
    }
  }

  @protected
  String get type;

  @protected
  bool get isCreated => _isCreated;

  @protected
  bool get isDisposed => _isDisposed;

  @protected
  String get nativeObjectId => _id;

  @protected
  dynamic getCreateArguments() => null;

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
  Future<T?> invokeMethod<T>(String method,{dynamic arguments}) async {
    await _createNativeObject();

    if (_isDisposed) {
      return null;
    }

    final response = await ArcgisNativeFlutterPlatform.instance.sendMessage<T>(
      objectId: _id,
      method: method,
      arguments: arguments,
    );

    return response;
  }

  @protected
  @mustCallSuper
  Future<void> handleMethodCall(String method, dynamic arguments) async {}

  @protected
  @mustCallSuper
  Future<void> onCreate() {
    return Future.value();
  }

  void _methodCallHandler(NativeMessage message) async {
    if (_isDisposed) {
      return;
    }
    await handleMethodCall(message.method, message.arguments);
  }

  Future<void> _createNativeObject() async {
    if (_isDisposed) {
      return;
    }

    if (!_isCreated) {
      _isCreated = true;
      await ArcgisNativeFlutterPlatform.instance.createNativeObject(
        objectId: _id,
        type: type,
        arguments: getCreateArguments(),
      );
      await onCreate();
      _onCreated.complete();
    }

    await _onCreated.future;
  }
}
