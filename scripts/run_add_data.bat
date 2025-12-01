@echo off
echo ========================================
echo Firebase Data Population Script
echo ========================================
echo.
echo This script will add sample data to your Firebase Firestore:
echo - 8 Categories (Electronics, Fashion, Home, Sports, etc.)
echo - 4 Promotional Banners
echo - 20 Products across all categories
echo.
echo Make sure Firebase is properly configured before running!
echo.
pause
echo.
echo Running script...
echo.
flutter run -d windows --target=scripts/add_sample_data.dart
echo.
echo ========================================
echo Script completed!
echo ========================================
pause

