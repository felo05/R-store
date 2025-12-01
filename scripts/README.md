# Firebase Data Population Scripts

This folder contains scripts to populate your Firebase Firestore database with sample data for testing and development.

## What Gets Added

### Categories (8 total)
- Electronics
- Fashion
- Home & Garden
- Sports
- Books
- Beauty
- Toys
- Food & Grocery

### Banners (4 total)
- Promotional banners with high-quality images

### Products (20 total)
- Various products distributed across all categories
- Each product includes:
  - Name and description
  - Price and old price (with discount)
  - High-quality product images from Unsplash
  - Category association
  - In-cart and in-favorites flags

## Prerequisites

1. **Firebase must be configured** - Run `flutterfire configure` first
2. **Internet connection** - Required to connect to Firebase
3. **Dart SDK** - Already included with Flutter

## How to Run

### Option 1: Using the Batch File (Easiest)
Simply double-click on `run_add_data.bat`

### Option 2: Using Command Line
```bash
dart run scripts/add_sample_data.dart
```

### Option 3: From Project Root
```bash
cd C:\Users\feloa\StudioProjects\e_commerce
dart run scripts/add_sample_data.dart
```

## What Happens

The script will:
1. Initialize Firebase connection
2. Add all categories with IDs and images
3. Add banner images for your home screen
4. Add 20 sample products with realistic data

## Data Structure

### Category Format
```dart
{
  'id': 1,
  'name': 'Electronics',
  'image': 'https://...',
}
```

### Banner Format
```dart
{
  'image': 'https://...',
}
```

### Product Format
```dart
{
  'name': 'Product Name',
  'description': 'Detailed description',
  'price': 149.99,
  'old_price': 199.99,
  'discount': 25,
  'image': 'https://...',
  'images': ['https://...', 'https://...'],
  'in_favorites': false,
  'in_cart': false,
  'category_id': 1,
}
```

## Important Notes

- **Existing Data**: This script adds new data. If you want to clear existing data first, do it manually in Firebase Console
- **Images**: All images are hosted on Unsplash (free, high-quality stock photos)
- **IDs**: Categories use fixed IDs (1-8), Products get auto-generated IDs from Firestore
- **Run Once**: You typically only need to run this once per project setup

## Troubleshooting

### "Firebase not initialized"
Make sure you've run `flutterfire configure` and that `firebase_options.dart` exists.

### "Permission denied"
Check your Firestore security rules. For development, you can use:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```
**⚠️ Change this for production!**

### "Network error"
- Check your internet connection
- Verify Firebase project is active in Firebase Console

## Customization

You can easily modify `add_sample_data.dart` to:
- Add more categories
- Change product details
- Use different images
- Adjust prices and discounts
- Add more products

## After Running

Once the script completes successfully:
1. Open Firebase Console
2. Go to Firestore Database
3. Verify the collections: `categories`, `banners`, `products`
4. Run your Flutter app - it should now display all the data!

## Clean Up

To remove all added data:
1. Go to Firebase Console
2. Navigate to Firestore Database
3. Delete the collections or individual documents as needed

Or create a cleanup script if needed frequently.

