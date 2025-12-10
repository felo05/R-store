import 'package:e_commerce/features/profile/model/profile_model.dart';

abstract class IStorageService {
  Future<void> init();
  bool isLoggedin();
  Future<void> inFirstTime();
  bool isFirstTime();
  Future<void> setToken(String token);
  String? getToken();
  Future<void> removeToken();
  Future<void> setUser(ProfileData user);
  ProfileData? getUser();
  Future<void> removeUser();
  Future<void> setLanguage(String langCode);
  String? getLanguage();
  String boxKey = "BoxKey";
  String userKey = "UserKey";
  String onboardKey = "OnboardKey";
  String tokenKey = "TokenKey";
  String langKey = "LangKey";
}

