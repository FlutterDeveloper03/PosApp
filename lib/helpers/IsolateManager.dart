// ignore_for_file: file_names

import 'dart:async';
import 'dart:collection';
import 'dart:isolate';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class IsolateManager {
  final int _maxIsolates;
  final List<Isolate> _isolates = [];
  final ReceivePort _receivePort = ReceivePort();
  final Queue<Task> _taskQueue = Queue<Task>();
  final Map<Task, Completer> _completers = {};
  int _activeIsolates = 0;

  IsolateManager({int maxIsolates = 4}) : _maxIsolates = maxIsolates {
    _receivePort.listen(_onMessageReceived);
  }

  void _onMessageReceived(dynamic message) {
    if (message is _IsolateResult) {
      _activeIsolates--;
      if(_taskQueue.isNotEmpty) {
        final task = _taskQueue.removeFirst();
        final completer = _completers.remove(task);
        if (message.error != null) {
          completer?.completeError(message.error!);
        } else {
          completer?.complete(message.result);
        }
      }

      _tryProcessQueue();
    }
  }

  Future<T> addTask<T>(Future<T> Function() function) async {
    final completer = Completer<T>();
    final task = Task<T>(function);
    _taskQueue.add(task);
    _completers[task] = completer;
    _tryProcessQueue();
    return completer.future;
  }

  void _tryProcessQueue() {
    while (_taskQueue.isNotEmpty && _activeIsolates < _maxIsolates) {
      final task = _taskQueue.first;
      _activeIsolates++;
      _spawnIsolate(task);
    }
  }

  void _spawnIsolate(Task task) async {
    final rootIsolateToken = RootIsolateToken.instance;
  if(rootIsolateToken != null) {
    final isolate = await Isolate.spawn(
      _isolateEntry,
      _IsolateMessage(task.function, _receivePort.sendPort, rootIsolateToken),
    );

    _isolates.add(isolate);
  }
  else{
    debugPrint('RootIsolateToken is null. Unable to spawn isolate.');
  }
  }

  static void _isolateEntry<T>(_IsolateMessage<T> message) async {
    BackgroundIsolateBinaryMessenger.ensureInitialized(message.rootIsolateToken);

    try {
      final result = await message.function();
      message.sendPort.send(_IsolateResult<T>(result, null));
    } catch (e) {
      message.sendPort.send(_IsolateResult<T>(null, e));
    }
  }

  void dispose() {
    for (final isolate in _isolates) {
      isolate.kill(priority: Isolate.immediate);
    }
    _isolates.clear();
  }
}

class _IsolateMessage<T> {
  final Future<T> Function() function;
  final SendPort sendPort;
  final RootIsolateToken rootIsolateToken;

  _IsolateMessage(this.function, this.sendPort, this.rootIsolateToken);
}

class _IsolateResult<T> {
  final T? result;
  final Object? error;

  _IsolateResult(this.result, this.error);
}

class Task<T> {
  final Future<T> Function() function;

  Task(this.function);
}
