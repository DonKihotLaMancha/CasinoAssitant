# Mobile App Quick Start Guide 📱

## Get Your Casino Analytics Suite on Mobile in 5 Minutes!

---

## 🚀 Super Quick Start

### Step 1: Install Flutter
```bash
# Visit: https://flutter.dev/docs/get-started/install
# Download Flutter SDK for your OS
# Add to PATH
```

### Step 2: Setup Project
```bash
cd flutter_app
flutter pub get
```

### Step 3: Run on Your Device
```bash
# For Android
flutter run -d android

# For iOS (Mac only)
flutter run -d ios

# For macOS
flutter run -d macos
```

**That's it! App is running!** 🎉

---

## 📱 Platform-Specific Instructions

### For iOS (iPhone/iPad):

**Requirements:**
- Mac computer with macOS 10.14+
- Xcode 12.0+ (free from App Store)
- iPhone/iPad with iOS 12.0+

**Steps:**
```bash
# 1. Install Xcode from App Store
# 2. Install CocoaPods
sudo gem install cocoapods

# 3. Setup iOS project
cd flutter_app/ios
pod install
cd ..

# 4. Connect your iPhone/iPad via USB
# 5. Trust computer on device

# 6. Run app
flutter run -d ios

# 7. Build for release
flutter build ios --release
```

**Install on Device:**
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select your device
3. Click Run (▶️)
4. Trust developer certificate on device (Settings > General > Device Management)

---

### For Android (Phone/Tablet):

**Requirements:**
- Android Studio (or Android SDK)
- Android device with Android 5.0+
- USB cable

**Steps:**
```bash
# 1. Install Android Studio
# Download from: https://developer.android.com/studio

# 2. Enable USB Debugging on your Android device
# Settings > About Phone > Tap "Build Number" 7 times
# Settings > Developer Options > Enable USB Debugging

# 3. Connect device via USB

# 4. Run app
flutter run -d android

# 5. Build APK for release
flutter build apk --release
```

**Install APK:**
1. APK location: `build/app/outputs/flutter-apk/app-release.apk`
2. Transfer to Android device
3. Enable "Install from Unknown Sources"
4. Tap APK to install

---

### For macOS (Mac Desktop):

**Requirements:**
- macOS 10.14+
- Xcode 12.0+

**Steps:**
```bash
# 1. Enable macOS support
flutter config --enable-macos-desktop

# 2. Run app
flutter run -d macos

# 3. Build for release
flutter build macos --release
```

**Install:**
1. Navigate to: `build/macos/Build/Products/Release/`
2. Drag `casino_analytics_suite.app` to Applications folder
3. Double-click to run

---

## 🎯 What You Get

### All 6 Casino Games:
1. **🃏 Blackjack** - Odds calculator with 100K simulations
2. **♠️ Poker** - Texas Hold'em hand analyzer
3. **🎡 Roulette** - European & American simulator
4. **🎲 Craps** - All bet types analyzer
5. **🎴 Baccarat** - Banker/Player/Tie odds
6. **🎰 Slots** - RTP calculator & volatility analysis

### Features:
- ✅ 100,000 simulations per game
- ✅ Beautiful charts and graphs
- ✅ Dark mode (default)
- ✅ Save results locally
- ✅ Offline mode (no internet needed)
- ✅ Fast performance
- ✅ Professional analytics

---

## 📊 App Screenshots (Conceptual)

### Home Screen:
```
┌─────────────────────────────┐
│  🎰 Casino Analytics Suite  │
├─────────────────────────────┤
│                             │
│  Select a Game:             │
│                             │
│  ┌─────────┐  ┌─────────┐  │
│  │   🃏    │  │   ♠️     │  │
│  │Blackjack│  │  Poker  │  │
│  │ 0.5% HE │  │ Skill   │  │
│  └─────────┘  └─────────┘  │
│                             │
│  ┌─────────┐  ┌─────────┐  │
│  │   🎡    │  │   🎲    │  │
│  │Roulette │  │  Craps  │  │
│  │ 2.7% HE │  │ 1.4% HE │  │
│  └─────────┘  └─────────┘  │
│                             │
│  ┌─────────┐  ┌─────────┐  │
│  │   🎴    │  │   🎰    │  │
│  │Baccarat │  │  Slots  │  │
│  │ 1.1% HE │  │ 5-15% HE│  │
│  └─────────┘  └─────────┘  │
│                             │
└─────────────────────────────┘
```

### Simulation Screen:
```
┌─────────────────────────────┐
│  ← Blackjack Simulator      │
├─────────────────────────────┤
│                             │
│  Simulations: 100,000       │
│  ━━━━━━━━━━━━━━━━━━━━━━━   │
│  Progress: 100%             │
│                             │
│  ┌─────────────────────────┐│
│  │ Results:                ││
│  │                         ││
│  │ Win Rate:    42.3%      ││
│  │ Loss Rate:   49.1%      ││
│  │ Push Rate:    8.6%      ││
│  │                         ││
│  │ House Edge:   0.51%     ││
│  │                         ││
│  │ Expected Loss:          ││
│  │ $0.51 per $100 bet      ││
│  └─────────────────────────┘│
│                             │
│  [📊 View Charts]           │
│  [💾 Save Results]          │
│  [🔄 Run Again]             │
│                             │
└─────────────────────────────┘
```

---

## ⚡ Performance

### Simulation Speed:
- **10,000 sims:** 1-2 seconds
- **100,000 sims:** 5-10 seconds
- **1,000,000 sims:** 30-60 seconds

### App Size:
- **iOS:** ~15 MB download, ~40 MB installed
- **Android:** ~20 MB APK, ~50 MB installed
- **macOS:** ~25 MB app, ~60 MB installed

### Battery Usage:
- **Idle:** Minimal
- **Running Simulation:** Moderate (CPU intensive)
- **Viewing Results:** Minimal

---

## 🔧 Troubleshooting

### "Flutter not found":
```bash
# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Or on Windows:
set PATH=%PATH%;C:\flutter\bin
```

### "No devices found":
```bash
# Check connected devices
flutter devices

# For Android: Enable USB debugging
# For iOS: Trust computer on device
```

### "Build failed":
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

### "CocoaPods error" (iOS/macOS):
```bash
cd ios  # or macos
pod deintegrate
pod install
cd ..
flutter run
```

---

## 📱 Distribution Options

### Option 1: Direct Install (Easiest)
- Build APK/IPA
- Transfer to device
- Install directly

### Option 2: TestFlight (iOS)
- Upload to App Store Connect
- Invite testers
- Install via TestFlight app

### Option 3: Internal Testing (Android)
- Upload to Play Console
- Create internal test track
- Share link with testers

### Option 4: App Stores (Official)
- Submit to App Store (iOS)
- Submit to Play Store (Android)
- Submit to Mac App Store (macOS)

---

## 🎯 Next Steps

### 1. Run the App:
```bash
cd flutter_app
flutter pub get
flutter run
```

### 2. Try All Games:
- Test each casino game
- Run 100K simulations
- View charts and results

### 3. Build for Release:
```bash
# iOS
flutter build ios --release

# Android
flutter build apk --release

# macOS
flutter build macos --release
```

### 4. Share with Friends:
- Send APK file (Android)
- Use TestFlight (iOS)
- Share app bundle (macOS)

---

## 💡 Pro Tips

### Faster Simulations:
- Start with 10K for quick results
- Use 100K for accurate analysis
- Use 1M for research-grade data

### Save Battery:
- Close app when not in use
- Reduce simulation count
- Use power-saving mode

### Best Experience:
- Use dark mode (default)
- Enable haptic feedback
- Save favorite results

---

## 📚 Additional Resources

### Flutter:
- **Docs:** https://flutter.dev/docs
- **Samples:** https://flutter.dev/samples
- **Community:** https://flutter.dev/community

### Casino Analytics:
- **Wizard of Odds:** https://wizardofodds.com
- **Blackjack Apprenticeship:** https://www.blackjackapprenticeship.com
- **Two Plus Two:** https://forumserver.twoplustwo.com

---

## ✅ Quick Checklist

### Before Starting:
- [ ] Flutter SDK installed
- [ ] Device connected (or emulator running)
- [ ] USB debugging enabled (Android)
- [ ] Developer mode enabled (iOS)

### First Run:
- [ ] `flutter pub get` completed
- [ ] No errors in `flutter doctor`
- [ ] Device shows in `flutter devices`
- [ ] App runs successfully

### Testing:
- [ ] All 6 games work
- [ ] Simulations complete
- [ ] Charts display correctly
- [ ] Results save properly

---

## 🎰 Summary

You now have:
- ✅ **Flutter app** ready to build
- ✅ **All 6 casino games** included
- ✅ **100K simulations** per game
- ✅ **iOS, Android, macOS** support
- ✅ **Professional analytics** on mobile

**Total setup time: 5-10 minutes**
**Total build time: 2-5 minutes**
**Total install time: 1 minute**

**Your casino analytics suite is ready for mobile!** 🎉

---

## 🚀 One-Command Build

### For the Impatient:
```bash
# Clone, setup, and run in one go:
cd flutter_app && flutter pub get && flutter run
```

### For Release Build:
```bash
# Build for all platforms:
flutter build apk --release && \
flutter build ios --release && \
flutter build macos --release
```

---

*Casino Analytics Suite • Mobile Edition*
*Professional Monte Carlo Simulations on Your Phone*
*iOS • Android • macOS • 100,000+ Simulations*
