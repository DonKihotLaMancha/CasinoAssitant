@echo off
echo ========================================
echo Casino Analytics Suite - Flutter Setup
echo ========================================
echo.

cd flutter_app

echo [1/4] Checking Flutter installation...
flutter --version
if %errorlevel% neq 0 (
    echo ERROR: Flutter is not installed!
    echo Please install Flutter from: https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)

echo.
echo [2/4] Getting dependencies...
flutter pub get

echo.
echo [3/4] Running Flutter doctor...
flutter doctor

echo.
echo [4/4] Setup complete!
echo.
echo ========================================
echo Next Steps:
echo ========================================
echo.
echo For Android:
echo   flutter run -d android
echo   flutter build apk --release
echo.
echo For iOS (Mac only):
echo   flutter run -d ios
echo   flutter build ios --release
echo.
echo For macOS (Mac only):
echo   flutter run -d macos
echo   flutter build macos --release
echo.
echo For Windows:
echo   flutter run -d windows
echo   flutter build windows --release
echo.
echo ========================================
pause
