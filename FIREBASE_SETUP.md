// Firebase configuration instructions
// 
// To complete the Firebase setup:
// 
// 1. Install Firebase CLI:
//    - Run: npm install -g firebase-tools
//    - Run: dart pub global activate flutterfire_cli
//
// 2. Login to Firebase:
//    - Run: firebase login
//
// 3. Create a Firebase project at https://console.firebase.google.com
//
// 4. Initialize Firebase in your project:
//    - Run: flutterfire configure
//    - Select your Firebase project
//    - Select platforms (Android, iOS)
//
// 5. Enable Firebase services in Firebase Console:
//    - Authentication: Enable Email/Password authentication
//    - Firestore Database: Create database in test mode
//    - Storage: Enable Firebase Storage
//
// 6. Firestore Database Structure:
//    Collections to create:
//    - users: User profile data
//    - products: Product catalog
//    - categories: Product categories
//    - banners: Banner images for home screen
//    - faqs: Frequently asked questions
//
//    Subcollections under users/{userId}:
//    - favorites: User's favorite products
//    - cart: User's shopping cart
//    - orders: User's order history
//    - addresses: User's saved addresses
//
// 7. Firestore Security Rules (update in Firebase Console):
//    rules_version = '2';
//    service cloud.firestore {
//      match /databases/{database}/documents {
//        // Public read for products, categories, banners, faqs
//        match /{document=**} {
//          allow read: if resource.data != null;
//        }
//        
//        match /products/{product} {
//          allow read: if true;
//        }
//        
//        match /categories/{category} {
//          allow read: if true;
//        }
//        
//        match /banners/{banner} {
//          allow read: if true;
//        }
//        
//        match /faqs/{faq} {
//          allow read: if true;
//        }
//        
//        // User-specific data
//        match /users/{userId} {
//          allow read, write: if request.auth != null && request.auth.uid == userId;
//          
//          match /{document=**} {
//            allow read, write: if request.auth != null && request.auth.uid == userId;
//          }
//        }
//      }
//    }
//
// 8. Sample Firestore Data Structure:
//
// products collection:
// {
//   "name": "Product Name",
//   "description": "Product description",
//   "price": 99.99,
//   "old_price": 129.99,
//   "discount": 23,
//   "image": "https://example.com/image.jpg",
//   "images": ["url1", "url2"],
//   "in_favorites": false,
//   "in_cart": false,
//   "category_id": 1
// }
//
// categories collection:
// {
//   "name": "Category Name",
//   "image": "https://example.com/category.jpg"
// }
//
// banners collection:
// {
//   "image": "https://example.com/banner.jpg"
// }

