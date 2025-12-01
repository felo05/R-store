import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseHelper {
  // Firebase instances
  static FirebaseAuth get auth => FirebaseAuth.instance;
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
  static FirebaseStorage get storage => FirebaseStorage.instance;

  // Collections
  static const String usersCollection = 'users';
  static const String productsCollection = 'products';
  static const String categoriesCollection = 'categories';
  static const String bannersCollection = 'banners';
  static const String favoritesCollection = 'favorites';
  static const String cartCollection = 'cart';
  static const String ordersCollection = 'orders';
  static const String addressesCollection = 'addresses';
  static const String faqsCollection = 'faqs';

  // Get current user ID
  static String? get currentUserId => auth.currentUser?.uid;

  // Check if user is logged in
  static bool get isLoggedIn => auth.currentUser != null;

  // Get user email
  static String? get userEmail => auth.currentUser?.email;
}

