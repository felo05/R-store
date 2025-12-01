import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:e_commerce/firebase_options.dart';

void main() async {
  print('🧹 Starting Firebase data cleanup script...');

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('✅ Firebase initialized successfully');

  final firestore = FirebaseFirestore.instance;

  print('\n⚠️  WARNING: This will delete ALL data from:');
  print('   - Categories collection');
  print('   - Banners collection');
  print('   - Products collection');
  print('\nPress Ctrl+C to cancel, or wait 5 seconds to continue...');

  await Future.delayed(const Duration(seconds: 5));

  try {
    // Delete Categories
    await deleteCollection(firestore, 'categories');

    // Delete Banners
    await deleteCollection(firestore, 'banners');

    // Delete Products
    await deleteCollection(firestore, 'products');

    print('\n✅ All data cleaned successfully!');
  } catch (e) {
    print('❌ Error: $e');
  }
}

Future<void> deleteCollection(FirebaseFirestore firestore, String collectionName) async {
  print('\n🗑️  Deleting $collectionName collection...');

  final snapshot = await firestore.collection(collectionName).get();

  for (var doc in snapshot.docs) {
    await doc.reference.delete();
    print('  ✓ Deleted: ${doc.id}');
  }

  print('✅ Deleted ${snapshot.docs.length} documents from $collectionName');
}

