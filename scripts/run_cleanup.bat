@echo off
echo ========================================
echo Firebase Data Cleanup Script
echo ========================================
echo.
echo WARNING: This will DELETE all sample data:
echo - All Categories
echo - All Banners
echo - All Products
echo.
echo Make sure you really want to do this!
echo.
pause
echo.
echo Running cleanup script...
echo.
dart run scripts/cleanup_data.dart
echo.
echo ========================================
echo Cleanup completed!
echo ========================================
pause

