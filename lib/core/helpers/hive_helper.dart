import 'package:e_commerce/features/profile/model/profile_model.dart';
import 'package:hive/hive.dart';
import 'package:e_commerce/core/helpers/firebase_helper.dart';

class HiveHelper {
  static String boxKey = "BoxKey";
  static String userKey = "UserKey";
  static String onboardKey = "OnboardKey";
  static String tokenKey = "TokenKey";
  static String langKey = "LangKey";

  static bool isLoggedin() {
    // Check Firebase authentication instead of token
    return FirebaseHelper.isLoggedIn;
  }

  static void inFirstTime() async {
    await Hive.box(boxKey).put(onboardKey, true);
  }

  static bool isFirstTime() {
    if (!Hive.box(boxKey).containsKey(onboardKey)) {
      return true;
    }
    return false;
  }

  static void setToken(String token) async {
    // Keep for compatibility, but Firebase handles tokens internally
    await Hive.box(boxKey).put(tokenKey, token);
  }

  static String? getToken() {
    // Return Firebase user ID as token
    return FirebaseHelper.currentUserId;
  }

  static void removeToken() async {
    await Hive.box(boxKey).delete(tokenKey);
  }

  static void setUser(ProfileData user) async {
    await Hive.box(boxKey).put(userKey,user);
  }

  static  ProfileData? getUser() {
    if(Hive.box(boxKey).containsKey(userKey)){
      return Hive.box(boxKey).get(userKey);
    }
    return null;
  }

  static void removeUser() async {
    await Hive.box(boxKey).delete(userKey);
  }

  static void setLanguage(String langCode) async {
    Hive.box(boxKey).put(langKey, langCode);
  }

  static String? getLanguage() {
    return Hive.box(boxKey).get(langKey);
  }
}
