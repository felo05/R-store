# 🔥 FIREBASE CONFIGURATION - STEP BY STEP

## Current Error:
```
Error getting App Check token; using placeholder token instead.
No AppCheckProvider installed.
```

This happens because Firebase is not fully configured for Android.

---

## 🚀 OPTION 1: Quick Fix - Run Without Firebase (Testing)

If you want to test the app without Firebase first:

### Update main.dart to skip Firebase temporarily:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Comment out Firebase for now
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  
  await Hive.initFlutter();
  Hive.registerAdapter(ProfileDataAdapter());
  await Hive.openBox(HiveHelper.boxKey);
  runApp(const MyApp());
}
```

**Note:** Authentication and data features won't work, but you can see the UI.

---

## ✅ OPTION 2: Proper Firebase Setup (Recommended)

Follow these steps carefully:

### Step 1: Install Firebase CLI

**Windows (PowerShell as Administrator):**
```powershell
npm install -g firebase-tools
```

**Or download standalone installer:**
https://firebase.google.com/docs/cli#windows-standalone-binary

### Step 2: Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

Add to PATH if needed:
```powershell
$env:PATH += ";$env:USERPROFILE\AppData\Local\Pub\Cache\bin"
```

### Step 3: Login to Firebase

```bash
firebase login
```

This will open a browser - login with your Google account.

### Step 4: Create Firebase Project

1. Go to https://console.firebase.google.com
2. Click "Add project"
3. Enter project name: `e-commerce-app` (or your choice)
4. Disable Google Analytics (optional for now)
5. Click "Create project"
6. Wait for setup to complete

### Step 5: Configure FlutterFire

In your project directory:

```bash
cd C:\Users\feloa\StudioProjects\e_commerce
flutterfire configure
```

**What this does:**
- Detects your Flutter project
- Shows your Firebase projects
- Select your project
- Choose platforms (Android, iOS, Web)
- Generates `firebase_options.dart` automatically
- Updates Android & iOS config files

**Answer the prompts:**
- Select Firebase project: Choose the one you created
- Which platforms: Android (press Space to select, Enter to confirm)

### Step 6: Enable Firebase Services

Go to Firebase Console: https://console.firebase.google.com

#### A. Enable Authentication
1. Click your project
2. Go to **Build** → **Authentication**
3. Click **Get Started**
4. Click **Sign-in method** tab
5. Click **Email/Password**
6. Enable the **first toggle** (Email/Password)
7. Click **Save**

#### B. Create Firestore Database
1. Go to **Build** → **Firestore Database**
2. Click **Create database**
3. Select **Start in test mode**
4. Choose a location (closest to you)
5. Click **Enable**

#### C. Update Firestore Rules (Important!)
In Firestore Database → Rules tab, replace with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow public read for products, categories, banners, faqs
    match /products/{product} {
      allow read: if true;
      allow write: if false;
    }
    
    match /categories/{category} {
      allow read: if true;
      allow write: if false;
    }
    
    match /banners/{banner} {
      allow read: if true;
      allow write: if false;
    }
    
    match /faqs/{faq} {
      allow read: if true;
      allow write: if false;
    }
    
    // User-specific data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      match /{subcollection=**} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

Click **Publish**

### Step 7: Add Sample Data to Firestore

In Firestore Database → Data tab:

#### Create "products" collection:
1. Click **Start collection**
2. Collection ID: `products`
3. Click **Next**
4. Document ID: `1`
5. Add fields:

```
name (string): "iPhone 14 Pro"
price (number): 999
old_price (number): 1099
discount (number): 9
image (string): "https://via.placeholder.com/300"
description (string): "Latest iPhone"
category_id (number): 1
in_favorites (boolean): false
in_cart (boolean): false
```

6. Click **Save**
7. Repeat for 5-10 products

#### Create "categories" collection:
```
id (number): 1
name (string): "Electronics"
image (string): "https://via.placeholder.com/150"
```

Add categories: Electronics, Fashion, Home, Sports

#### Create "banners" collection:
```
image (string): "https://via.placeholder.com/600x200"
```

Add 3-5 banners

### Step 8: Run Your App

```bash
flutter clean
flutter pub get
flutter run
```

---

## 📱 Android-Specific Setup (If Still Getting Errors)

### Update android/build.gradle:

```gradle
buildscript {
    ext.kotlin_version = '1.9.0'
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:8.1.0'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        classpath 'com.google.gms:google-services:4.4.0'  // Add this
    }
}
```

### Update android/app/build.gradle:

At the bottom of the file, add:
```gradle
apply plugin: 'com.google.gms.google-services'
```

### Update android/gradle.properties:

Add:
```properties
android.useAndroidX=true
android.enableJetifier=true
```

---

## 🔧 Troubleshooting

### Error: "flutterfire: command not found"

Add to PATH:
```powershell
$env:PATH += ";$env:USERPROFILE\AppData\Local\Pub\Cache\bin"
```

Or use full path:
```bash
dart pub global run flutterfire_cli:flutterfire configure
```

### Error: "firebase: command not found"

Reinstall Firebase CLI or use:
```bash
npx firebase-tools login
```

### Error: "No Firebase project found"

Make sure you created a project in Firebase Console first.

### Still getting App Check warning?

This is just a warning and won't break your app. To remove it, you can add App Check (optional):

In Firebase Console → Build → App Check → Register your app

---

## ✅ Verify Everything Works

After setup, test:

1. **Run app** - Should start without Firebase errors
2. **Register user** - Check Firebase Console → Authentication
3. **View products** - Should show data from Firestore
4. **Add to cart** - Check Firestore → users/{userId}/cart

---

## 🎯 Expected Result

After proper configuration:
- ✅ No Firebase initialization errors
- ✅ Authentication works
- ✅ Products display from Firestore
- ✅ Cart, favorites, orders all work

---

## 📞 Need Help?

If you get stuck:
1. Check Firebase Console for errors
2. Run `flutter doctor` to check setup
3. Check `firebase_options.dart` was generated
4. Verify internet connection
5. Check Firebase Console → Project Settings → Your apps

---

**Quick Command Summary:**
```bash
# Install tools
npm install -g firebase-tools
dart pub global activate flutterfire_cli

# Login and configure
firebase login
cd C:\Users\feloa\StudioProjects\e_commerce
flutterfire configure

# Run app
flutter clean
flutter pub get
flutter run
```

