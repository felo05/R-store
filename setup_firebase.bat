@echo off
echo ========================================
echo Firebase Configuration Helper
echo ========================================
echo.

echo Step 1: Checking if Firebase CLI is installed...
where firebase >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Firebase CLI not found!
    echo.
    echo Please install Firebase CLI first:
    echo   npm install -g firebase-tools
    echo.
    echo Or download from: https://firebase.google.com/docs/cli
    pause
    exit /b
)
echo [OK] Firebase CLI found!
echo.

echo Step 2: Checking if FlutterFire CLI is installed...
where flutterfire >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] FlutterFire CLI not found. Installing...
    call dart pub global activate flutterfire_cli
    echo [OK] FlutterFire CLI installed!
) else (
    echo [OK] FlutterFire CLI found!
)
echo.

echo Step 3: Logging into Firebase...
call firebase login
if %errorlevel% neq 0 (
    echo [ERROR] Firebase login failed!
    pause
    exit /b
)
echo [OK] Logged into Firebase!
echo.

echo Step 4: Configuring Firebase for your Flutter project...
echo This will:
echo   - Show your Firebase projects
echo   - Let you select which platforms to support
echo   - Generate firebase_options.dart automatically
echo.
pause

call flutterfire configure
if %errorlevel% neq 0 (
    echo [ERROR] Firebase configuration failed!
    pause
    exit /b
)
echo.
echo ========================================
echo [SUCCESS] Firebase configured!
echo ========================================
echo.
echo Next steps:
echo 1. Go to Firebase Console: https://console.firebase.google.com
echo 2. Enable Authentication (Email/Password)
echo 3. Create Firestore Database (test mode)
echo 4. Add sample data to Firestore
echo.
echo Then run: flutter run
echo.
pause

