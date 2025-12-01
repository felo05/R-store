import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import '../lib/firebase_options.dart';

void main() async {
  print('🚀 Starting Firebase data population script...');

  // Initialize Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('✅ Firebase initialized successfully');

  final firestore = FirebaseFirestore.instance;

  try {
    // Add Categories
    await addCategories(firestore);

    // Add Banners
    await addBanners(firestore);

    // Add Products
    await addProducts(firestore);

    print('\n🎉 All data added successfully!');
    print('✨ Your e-commerce app is now populated with sample data.');
    exit(0);
  } catch (e) {
    print('❌ Error: $e');
    exit(1);
  }
}

Future<void> addCategories(FirebaseFirestore firestore) async {
  print('\n📁 Adding Categories...');

  final categories = [
    {
      'id': 1,
      'name': 'Electronics',
      'image': 'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=400',
    },
    {
      'id': 2,
      'name': 'Fashion',
      'image': 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=400',
    },
    {
      'id': 3,
      'name': 'Home & Garden',
      'image': 'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=400',
    },
    {
      'id': 4,
      'name': 'Sports',
      'image': 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=400',
    },
    {
      'id': 5,
      'name': 'Books',
      'image': 'https://images.unsplash.com/photo-1495446815901-a7297e633e8d?w=400',
    },
    {
      'id': 6,
      'name': 'Beauty',
      'image': 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400',
    },
    {
      'id': 7,
      'name': 'Toys',
      'image': 'https://images.unsplash.com/photo-1558060370-d644479cb6f7?w=400',
    },
    {
      'id': 8,
      'name': 'Food & Grocery',
      'image': 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
    },
  ];

  for (var category in categories) {
    await firestore.collection('categories').doc(category['id'].toString()).set(category);
    print('  ✓ Added: ${category['name']}');
  }

  print('✅ Categories added: ${categories.length}');
}

Future<void> addBanners(FirebaseFirestore firestore) async {
  print('\n🎨 Adding Banners...');

  final banners = [
    {
      'image': 'https://images.unsplash.com/photo-1607083206869-4c7672e72a8a?w=800',
    },
    {
      'image': 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800',
    },
    {
      'image': 'https://images.unsplash.com/photo-1607082349566-187342175e2f?w=800',
    },
    {
      'image': 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800',
    },
  ];

  for (int i = 0; i < banners.length; i++) {
    await firestore.collection('banners').doc('banner_${i + 1}').set(banners[i]);
    print('  ✓ Added: Banner ${i + 1}');
  }

  print('✅ Banners added: ${banners.length}');
}

Future<void> addProducts(FirebaseFirestore firestore) async {
  print('\n📦 Adding Products...');

  final products = [
    // Electronics
    {
      'name': 'Wireless Headphones',
      'description': 'High-quality wireless headphones with noise cancellation and 30-hour battery life. Perfect for music lovers and professionals.',
      'price': 149.99,
      'old_price': 199.99,
      'discount': 25,
      'image': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500',
      'images': [
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500',
        'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=500',
      ],
      'in_favorites': false,
      'in_cart': false,
      'category_id': 1,
    },
    {
      'name': 'Smart Watch',
      'description': 'Advanced fitness tracker with heart rate monitor, GPS, and smartphone notifications. Water-resistant design.',
      'price': 299.99,
      'old_price': 349.99,
      'discount': 14,
      'image': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
      'images': [
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
        'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=500',
      ],
      'in_favorites': false,
      'in_cart': false,
      'category_id': 1,
    },
    {
      'name': 'Laptop Pro',
      'description': 'Powerful laptop with Intel i7 processor, 16GB RAM, 512GB SSD. Perfect for work and entertainment.',
      'price': 1299.99,
      'old_price': 1499.99,
      'discount': 13,
      'image': 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=500',
      'images': [
        'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=500',
        'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500',
      ],
      'in_favorites': false,
      'in_cart': false,
      'category_id': 1,
    },
    {
      'name': 'Wireless Mouse',
      'description': 'Ergonomic wireless mouse with precision tracking and long battery life. Compatible with all devices.',
      'price': 29.99,
      'old_price': 39.99,
      'discount': 25,
      'image': 'https://images.unsplash.com/photo-1527814050087-3793815479db?w=500',
      'images': [
        'https://images.unsplash.com/photo-1527814050087-3793815479db?w=500',
      ],
      'in_favorites': false,
      'in_cart': false,
      'category_id': 1,
    },

    // Fashion
    {
      'name': 'Classic T-Shirt',
      'description': 'Comfortable cotton t-shirt in various colors. Perfect for casual wear. Available in S, M, L, XL.',
      'price': 24.99,
      'old_price': 34.99,
      'discount': 29,
      'image': 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500',
      'images': [
        'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500',
        'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=500',
      ],
      'in_favorites': false,
      'in_cart': false,
      'category_id': 2,
    },
    {
      'name': 'Denim Jeans',
      'description': 'Classic blue denim jeans with a perfect fit. Durable and stylish for everyday wear.',
      'price': 59.99,
      'old_price': 79.99,
      'discount': 25,
      'image': 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=500',
      'images': [
        'https://images.unsplash.com/photo-1542272604-787c3835535d?w=500',
      ],
      'in_favorites': false,
      'in_cart': false,
      'category_id': 2,
    },
    {
      'name': 'Leather Jacket',
      'description': 'Premium leather jacket with modern design. Perfect for all seasons.',
      'price': 199.99,
      'old_price': 299.99,
      'discount': 33,
      'image': 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=500',
      'images': [
        'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=500',
      ],
      'in_favorites': false,
      'in_cart': false,
      'category_id': 2,
    },
    {
      'name': 'Summer Dress',
      'description': 'Elegant summer dress with floral pattern. Lightweight and comfortable for warm weather.',
      'price': 79.99,
      'old_price': 99.99,
      'discount': 20,
      'image': 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=500',
      'images': [
        'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=500',
      ],
      'in_favorites': false,
      'in_cart': false,
      'category_id': 2,
    },

    // Home & Garden
    {
      'name': 'Modern Coffee Table',
      'description': 'Stylish coffee table with storage space. Made from high-quality wood with a modern finish.',
      'price': 249.99,
      'old_price': 349.99,
      'discount': 29,
      'image': 'https://images.unsplash.com/photo-1611269154421-4e27233ac5c7?w=500',
      'images': [
        'https://images.unsplash.com/photo-1611269154421-4e27233ac5c7?w=500',
      ],
      'in_favorites': false,
      'in_cart': false,
      'category_id': 3,
    },
    {
      'name': 'Indoor Plant Set',
      'description': 'Set of 3 beautiful indoor plants with decorative pots. Perfect for home decoration.',
      'price': 49.99,
      'old_price': 69.99,
      'discount': 29,
      'image': 'https://images.unsplash.com/photo-1485955900006-10f4d324d411?w=500',
      'images': [
        'https://images.unsplash.com/photo-1485955900006-10f4d324d411?w=500',
      ],
      'in_favorites': false,
      'in_cart': false,
      'category_id': 3,
    },

    // Sports
    {
      'name': 'Yoga Mat',
      'description': 'Non-slip yoga mat with extra cushioning. Perfect for yoga, pilates, and floor exercises.',
      'price': 34.99,
      'old_price': 49.99,
      'discount': 30,
      'image': 'https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f?w=500',
      'images': [
        'https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f?w=500',
      ],
      'in_favorites': false,
      'in_cart': false,
      'category_id': 4,
    },
    {
      'name': 'Running Shoes',
      'description': 'Professional running shoes with excellent cushioning and support. Available in multiple sizes.',
      'price': 89.99,
      'old_price': 119.99,
      'discount': 25,
      'image': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500',
      'images': [
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500',
      ],
      'in_favorites': false,
      'in_cart': false,
      'category_id': 4,
    },

    // Books
    {
      'name': 'Programming Book Set',
      'description': 'Complete guide to modern programming. Perfect for beginners and advanced developers.',
      'price': 79.99,
      'old_price': 99.99,
      'discount': 20,
      'image': 'https://images.unsplash.com/photo-1532012197267-da84d127e765?w=500',
      'images': [
        'https://images.unsplash.com/photo-1532012197267-da84d127e765?w=500',
      ],
      'in_favorites': false,
      'in_cart': false,
      'category_id': 5,
    },
    {
      'name': 'Mystery Novel Collection',
      'description': 'Bestselling mystery novels bundle. Thrilling stories that will keep you on the edge.',
      'price': 39.99,
      'old_price': 59.99,
      'discount': 33,
      'image': 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=500',
      'images': [
        'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=500',
      ],
      'in_favorites': false,
      'in_cart': false,
      'category_id': 5,
    },

    // Beauty
    {
      'name': 'Skincare Set',
      'description': 'Complete skincare routine set with cleanser, toner, and moisturizer. Suitable for all skin types.',
      'price': 69.99,
      'old_price': 99.99,
      'discount': 30,
      'image': 'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=500',
      'images': [
        'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=500',
      ],
      'in_favorites': false,
      'in_cart': false,
      'category_id': 6,
    },
    {
      'name': 'Makeup Brush Set',
      'description': 'Professional makeup brush set with 12 pieces. Perfect for all makeup applications.',
      'price': 44.99,
      'old_price': 64.99,
      'discount': 31,
      'image': 'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?w=500',
      'images': [
        'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?w=500',
      ],
      'in_favorites': false,
      'in_cart': false,
      'category_id': 6,
    },

    // Toys
    {
      'name': 'Building Blocks Set',
      'description': 'Creative building blocks for kids. 500+ pieces for endless fun and learning.',
      'price': 49.99,
      'old_price': 69.99,
      'discount': 29,
      'image': 'https://images.unsplash.com/photo-1587654780291-39c9404d746b?w=500',
      'images': [
        'https://images.unsplash.com/photo-1587654780291-39c9404d746b?w=500',
      ],
      'in_favorites': false,
      'in_cart': false,
      'category_id': 7,
    },
    {
      'name': 'Stuffed Animal',
      'description': 'Soft and cuddly stuffed animal toy. Perfect for kids of all ages.',
      'price': 24.99,
      'old_price': 34.99,
      'discount': 29,
      'image': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=500',
      'images': [
        'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=500',
      ],
      'in_favorites': false,
      'in_cart': false,
      'category_id': 7,
    },

    // Food & Grocery
    {
      'name': 'Organic Coffee Beans',
      'description': 'Premium organic coffee beans. Rich flavor and aroma. 1kg pack.',
      'price': 19.99,
      'old_price': 24.99,
      'discount': 20,
      'image': 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=500',
      'images': [
        'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=500',
      ],
      'in_favorites': false,
      'in_cart': false,
      'category_id': 8,
    },
    {
      'name': 'Olive Oil Set',
      'description': 'Extra virgin olive oil collection. Perfect for cooking and salads.',
      'price': 29.99,
      'old_price': 39.99,
      'discount': 25,
      'image': 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=500',
      'images': [
        'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=500',
      ],
      'in_favorites': false,
      'in_cart': false,
      'category_id': 8,
    },
  ];

  for (var product in products) {
    await firestore.collection('products').add(product);
    print('  ✓ Added: ${product['name']}');
  }

  print('✅ Products added: ${products.length}');
}
