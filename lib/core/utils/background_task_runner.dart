import 'dart:isolate';
import 'package:flutter/foundation.dart';

/// BackgroundTaskRunner - Utility for running heavy operations off the main thread
///
/// This class provides utilities to run CPU-intensive tasks in separate isolates
/// to prevent blocking the UI thread and causing frame drops
class BackgroundTaskRunner {
  /// Run a CPU-intensive function in a separate isolate using compute
  ///
  /// Example:
  /// ```dart
  /// final result = await BackgroundTaskRunner.runTask(
  ///   heavyComputation,
  ///   inputData,
  /// );
  /// ```
  static Future<R> runTask<Q, R>(
    ComputeCallback<Q, R> callback,
    Q message, {
    String? debugLabel,
  }) async {
    return compute(callback, message, debugLabel: debugLabel);
  }

  /// Run a list of independent tasks concurrently in separate isolates
  ///
  /// Example:
  /// ```dart
  /// final results = await BackgroundTaskRunner.runTasksInParallel([
  ///   () => compute(task1, data1),
  ///   () => compute(task2, data2),
  /// ]);
  /// ```
  static Future<List<T>> runTasksInParallel<T>(
    List<Future<T> Function()> tasks,
  ) async {
    return Future.wait(tasks.map((task) => task()));
  }

  /// Run a task with a timeout
  /// Returns null if the task times out
  static Future<R?> runTaskWithTimeout<Q, R>(
    ComputeCallback<Q, R> callback,
    Q message, {
    required Duration timeout,
    String? debugLabel,
  }) async {
    try {
      return await compute(callback, message, debugLabel: debugLabel)
          .timeout(timeout);
    } catch (e) {
      debugPrint('Task timed out: $e');
      return null;
    }
  }

  /// Check if the current code is running in the main isolate
  static bool get isMainIsolate {
    try {
      // This will throw in isolates
      return Isolate.current.debugName == 'main';
    } catch (e) {
      return false;
    }
  }
}

/// Helper functions for common heavy operations
class HeavyOperations {
  /// Parse large JSON in background
  static Future<Map<String, dynamic>> parseJsonInBackground(
    String jsonString,
  ) async {
    return BackgroundTaskRunner.runTask(
      _parseJson,
      jsonString,
      debugLabel: 'ParseJSON',
    );
  }

  static Map<String, dynamic> _parseJson(String jsonString) {
    // Add JSON parsing here if needed
    // For now, just a placeholder
    return {};
  }

  /// Process large list in background
  static Future<List<T>> processListInBackground<T>(
    List<T> items,
    T Function(T) processor,
  ) async {
    return BackgroundTaskRunner.runTask(
      _processList,
      _ProcessListMessage(items, processor),
      debugLabel: 'ProcessList',
    );
  }

  static List<T> _processList<T>(_ProcessListMessage<T> message) {
    return message.items.map(message.processor).toList();
  }
}

class _ProcessListMessage<T> {
  final List<T> items;
  final T Function(T) processor;

  _ProcessListMessage(this.items, this.processor);
}

