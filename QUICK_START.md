# Quick Start Guide - Fix Firebase Error

## 🔴 Current Error:
```
Error getting App Check token; using placeholder token instead.
No AppCheckProvider installed.
```

## ✅ Quick Solution (3 Options)

---

### OPTION 1: Use the Automatic Setup Script (Easiest)

1. **Open PowerShell as Administrator**

2. **Install Node.js** (if not installed):
   - Download from: https://nodejs.org
   - Install and restart terminal

3. **Run the setup script:**
   ```powershell
   cd C:\Users\feloa\StudioProjects\e_commerce
   .\setup_firebase.bat
   ```

4. **Follow the prompts:**
   - Login to Firebase (browser will open)
   - Select your Firebase project (or create new)
   - Choose Android platform
   - Done!

---

### OPTION 2: Manual Setup (5 Commands)

```bash
# 1. Install Firebase CLI
npm install -g firebase-tools

# 2. Install FlutterFire CLI
dart pub global activate flutterfire_cli

# 3. Login to Firebase
firebase login

# 4. Configure Firebase for your project
cd C:\Users\feloa\StudioProjects\e_commerce
flutterfire configure

# 5. Run your app
flutter run
```

---

### OPTION 3: Test Without Firebase (Temporary)

If you just want to see the UI without Firebase:

**Comment out Firebase in main.dart:**

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // TODO: Uncomment after Firebase setup
  // try {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  // } catch (e) {
  //   debugPrint('Firebase error: $e');
  // }
  
  await Hive.initFlutter();
  Hive.registerAdapter(ProfileDataAdapter());
  await Hive.openBox(HiveHelper.boxKey);
  runApp(const MyApp());
}
```

**Then run:**
```bash
flutter run
```

**Note:** Authentication and data features won't work, but you can see the UI.

---

## 📋 After Firebase Configuration

### 1. Create Firebase Project
- Go to https://console.firebase.google.com
- Click "Add project"
- Name it "e-commerce-app"
- Click "Create project"

### 2. Enable Authentication
- In Firebase Console → Authentication
- Click "Get Started"
- Enable "Email/Password"

### 3. Create Firestore Database
- Go to Firestore Database
- Click "Create database"
- Select "Test mode"
- Click "Enable"

### 4. Add Sample Data

In Firestore, create these collections:

**products:**
```json
{
  "id": 1,
  "name": "iPhone 14 Pro",
  "price": 999,
  "image": "https://via.placeholder.com/300",
  "category_id": 1
}
```

**categories:**
```json
{
  "id": 1,
  "name": "Electronics",
  "image": "https://via.placeholder.com/150"
}
```

**banners:**
```json
{
  "image": "https://via.placeholder.com/600x200"
}
```

Add 5-10 items in each collection.

---

## ✅ Verify It Works

After setup:
1. Run `flutter run`
2. Register a new user
3. Check Firebase Console → Authentication (user should appear)
4. Browse products (should show from Firestore)

---

## 🆘 Troubleshooting

### "firebase: command not found"
Install Node.js first, then: `npm install -g firebase-tools`

### "flutterfire: command not found"
Run: `dart pub global activate flutterfire_cli`

Then add to PATH:
```powershell
$env:PATH += ";$env:USERPROFILE\AppData\Local\Pub\Cache\bin"
```

### "No Firebase project found"
Create a project in Firebase Console first

### Still getting App Check warning?
It's just a warning - app will work fine. To remove it:
- Firebase Console → App Check → Register app (optional)

---

## 🎯 Choose Your Path:

- **Just want to test?** → Use Option 3 (comment out Firebase)
- **Want full features?** → Use Option 1 (run script) or Option 2 (manual)

The setup takes about 5-10 minutes total!

