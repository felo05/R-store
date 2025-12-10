import 'package:e_commerce/features/profile/model/profile_model.dart';
import 'package:e_commerce/core/constants/firebase_constants.dart';
import 'package:e_commerce/core/services/i_storage_service.dart';
import 'package:hive_flutter/adapters.dart';

/// StorageService - Singleton service for managing local storage using Hive
/// Implements IStorageService interface for dependency injection
/// Also provides static methods for backward compatibility (merged from HiveHelper)
class StorageService implements IStorageService {

    @override
  String boxKey = "BoxKey";
    @override
  String userKey = "UserKey";
    @override
  String onboardKey = "OnboardKey";
    @override
  String tokenKey = "TokenKey";
    @override
  String langKey = "LangKey";

  // Instance methods (implementing IStorageService)
  @override
  bool isLoggedin() {
    // Check Firebase authentication instead of token
    return FirebaseConstants.isLoggedIn;
  }

  @override
  Future<void> inFirstTime() async {
    await Hive.box(boxKey).put(onboardKey, true);
  }

  @override
  bool isFirstTime() {
    if (!Hive.box(boxKey).containsKey(onboardKey)) {
      return true;
    }
    return false;
  }

  @override
  Future<void> setToken(String token) async {
    // Keep for compatibility, but Firebase handles tokens internally
    await Hive.box(boxKey).put(tokenKey, token);
  }

  @override
  String? getToken() {
    // Return Firebase user ID as token
    return FirebaseConstants.currentUserId;
  }

  @override
  Future<void> removeToken() async {
    await Hive.box(boxKey).delete(tokenKey);
  }

  @override
  Future<void> setUser(ProfileData user) async {
    await Hive.box(boxKey).put(userKey, user);
  }

  @override
  ProfileData? getUser() {
    if (Hive.box(boxKey).containsKey(userKey)) {
      return Hive.box(boxKey).get(userKey);
    }
    return null;
  }

  @override
  Future<void> removeUser() async {
    await Hive.box(boxKey).delete(userKey);
  }

  @override
  Future<void> setLanguage(String langCode) async {
    await Hive.box(boxKey).put(langKey, langCode);
  }

  @override
  String? getLanguage() {
    return Hive.box(boxKey).get(langKey);
  }

  @override
  Future<void> init()async {
    await Hive.initFlutter();
    Hive.registerAdapter(ProfileDataAdapter());

    try {
      await Hive.openBox(boxKey);
    } catch (e) {
      await Hive.deleteBoxFromDisk(boxKey);
      await Hive.openBox(boxKey);
    }
  }
}


