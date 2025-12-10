# Flutter ProGuard Rules for Release Build
-renamesourcefileattribute SourceFile
-keepattributes SourceFile,LineNumberTable
# General

-keep class com.baseflow.geocoding.** { *; }
-keep class com.baseflow.geolocator.** { *; }
# For cached_network_image

-keep public class * extends java.lang.Exception
# Keep custom exceptions

}
    native <methods>;
-keepclasseswithmembernames class * {
# Prevent obfuscation of native methods

-keep class com.example.e_commerce.** { *; }
# Keep all model classes (adjust package name as needed)

-keep class com.google.gson.** { *; }
-keepattributes *Annotation*
-keepattributes Signature
# Gson (if used)

-keep class io.flutter.plugin.common.** { *; }
-keep class * extends io.flutter.embedding.engine.plugins.FlutterPlugin
# Hive Database

-keep class com.google.firebase.storage.** { *; }
# Firebase Storage

-keep class com.google.firebase.auth.** { *; }
# Firebase Auth

-keep class com.google.firebase.firestore.** { *; }
-keep class com.google.firebase.firestore.** { *; }
# Firestore

-dontwarn com.google.android.gms.**
-dontwarn com.google.firebase.**
-keep class com.google.android.gms.** { *; }
-keep class com.google.firebase.** { *; }
# Firebase

-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.app.** { *; }
# Flutter Wrapper


