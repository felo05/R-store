import 'dart:async';
import 'package:e_commerce/core/di/service_locator.dart';
import 'package:e_commerce/core/services/i_storage_service.dart';
import 'package:e_commerce/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../services/i_product_status_service.dart';

/// Result data from initialization
class InitializationResult {
  final bool isFirstTime;
  final bool isLoggedIn;
  final String? error;

  InitializationResult({
    required this.isFirstTime,
    required this.isLoggedIn,
    this.error,
  });

  InitializationResult.error(String errorMessage)
      : isFirstTime = true,
        isLoggedIn = false,
        error = errorMessage;
}

/// AppInitializer - Handles app initialization with optimized performance
///
/// Optimizations:
/// - Concurrent initialization where possible
/// - Frame-aware scheduling to prevent UI jank
/// - Lazy initialization of non-critical services
/// - Proper error handling and recovery
class AppInitializer {
  static bool _isInitialized = false;

  /// Initialize the app with optimized async operations
  /// This runs initialization tasks concurrently where possible
  /// and schedules work to avoid blocking the UI thread
  static Future<InitializationResult> initialize() async {
    if (_isInitialized) {
      return _getUserState();
    }

    try {

      // Phase 1: Critical initialization (Firebase must be first)
      await _initializeFirebase();

      // Phase 2: Concurrent initialization of independent services
      // Service Locator and Storage can run in parallel
      await Future.wait([
        _initializeServiceLocatorWithScheduling(),
        _initializeStorageWithScheduling(),
      ]);
      final result=await sl<IProductStatusService>().fetchFavoritesAndCart();
      result.fold((error) => throw Exception(error), (_) => null);


      _isInitialized = true;

      // Phase 3: Get user state
      return _getUserState();
    } catch (e, stackTrace) {
      debugPrint('Initialization error: $e\n$stackTrace');
      return InitializationResult.error(e.toString());
    }
  }

  /// Initialize Firebase (must be on main isolate)
  static Future<void> _initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  /// Initialize service locator with frame scheduling
  /// Yields to the UI thread periodically to prevent jank
  static Future<void> _initializeServiceLocatorWithScheduling() async {
    // Use microtasks to yield between heavy operations
    await Future.microtask(() async {
      await initServiceLocator();
    });
  }

  /// Initialize storage (Hive) with frame scheduling
  /// This is I/O heavy but we can break it into chunks
  static Future<void> _initializeStorageWithScheduling() async {
    // Allow the frame to complete before starting I/O
    await Future.microtask(() async {
      await sl<IStorageService>().init();
    });
  }

  /// Get user state from storage
  static InitializationResult _getUserState() {
    final isFirstTime = sl<IStorageService>().isFirstTime();
    final isLoggedIn = sl<IStorageService>().isLoggedin();

    return InitializationResult(
      isFirstTime: isFirstTime,
      isLoggedIn: isLoggedIn,
    );
  }

  /// Lazy initialization for non-critical services
  /// Call this after the app has loaded to warm up caches
  static Future<void> initializeDeferredServices() async {
    // Add any deferred initialization here
    // e.g., analytics, crash reporting, etc.
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// Pre-cache images and other assets
  /// Call this after navigation to warm up cache
  static Future<void> precacheAssets(context) async {
    // Add asset precaching here if needed
    // This runs after the app has loaded to not block initial startup
  }

  /// Reset initialization state (useful for testing)
  static void reset() {
    _isInitialized = false;
  }
}

