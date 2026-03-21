# Firebase Setup - Terminal Commands Guide

## Step-by-Step Commands to Complete Setup

### **Step 1: Enable Windows Developer Mode** (Open Settings)
```powershell
# Option A: Use this command to open settings
start ms-settings:developers
```

Then toggle "Developer Mode" to ON.

---

### **Step 2: Navigate to Your Project**
```powershell
cd C:\Users\ardhr\Desktop\minipro_13\miniprj_2
```

---

### **Step 3: Install FlutterFire CLI**
```powershell
dart pub global activate flutterfire_cli
```

If this doesn't work, use:
```powershell
flutter pub global activate flutterfire_cli
```

---

### **Step 4: Configure Firebase for iOS** (If building for iOS)
```powershell
flutterfire configure
```

**When prompted:**
- Select your Firebase project: Type number for `seating-arrangement-73a5d`
- Select platforms: Choose `1` for Android and/or `2` for iOS
- The tool will generate `firebase_options.dart`

---

### **Step 5: Clean and Get Dependencies**
```powershell
flutter clean
flutter pub get
```

---

### **Step 6: Verify Setup**
```powershell
flutter doctor
```

Check that all items show green checkmarks.

---

### **Step 7: Test Run the App**
```powershell
# For Android emulator
flutter run

# Or specify device
flutter run -d emulator-5554
```

---

## Command Summary (All in One)

```powershell
# Navigate to project
cd C:\Users\ardhr\Desktop\minipro_13\miniprj_2

# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase (follow prompts)
flutterfire configure

# Clean and get dependencies
flutter clean
flutter pub get

# Verify setup
flutter doctor

# Run the app
flutter run
```

---

## Troubleshooting Commands

### **If you get "Command not found" for flutterfire**
```powershell
# Add Dart to PATH and try again
dart pub global activate flutterfire_cli

# Or directly use the command
C:\Users\[YourUsername]\AppData\Local\Pub\Cache\bin\flutterfire.bat configure
```

### **If you get dependency conflicts**
```powershell
# Update dependencies to compatible versions
flutter pub get
flutter pub upgrade --major-versions

# If still having issues, downgrade problematic package
flutter pub add cloud_firestore@5.4.0
```

### **If build fails**
```powershell
# Deep clean
flutter clean
del pubspec.lock

# Fresh install
flutter pub get
```

### **Check Android setup**
```powershell
flutter doctor -v
```

Look for Android SDK, NDK, and Gradle warnings.

---

## Commands to Verify Firebase Integration

### **Check if google-services.json exists**
```powershell
Test-Path "C:\Users\ardhr\Desktop\minipro_13\miniprj_2\android\app\google-services.json"
```

Expected output: `True`

### **Check if firebase_options.dart exists**
```powershell
Test-Path "C:\Users\ardhr\Desktop\minipro_13\miniprj_2\lib\firebase_options.dart"
```

Expected output: `True` (after running `flutterfire configure`)

### **List all dependencies**
```powershell
flutter pub deps
```

You should see all Firebase packages listed.

---

## IDE-Specific Commands

### **In Android Studio Terminal**
Same as above - just open **Terminal** tab (View → Tool Windows → Terminal)

```
cd C:\Users\ardhr\Desktop\minipro_13\miniprj_2
flutterfire configure
flutter clean
flutter pub get
flutter run
```

### **In VS Code Terminal**
Same commands - open Terminal (Ctrl + `)

---

## Building for Release

### **Build APK (Android Release)**
```powershell
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### **Build App Bundle (For Google Play Store)**
```powershell
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### **Build iOS (macOS only)**
```powershell
flutter build ios --release
```

---

## Useful Flutter/Dart Commands

```powershell
# Check Flutter version
flutter --version

# Check Dart version
dart --version

# List available devices
flutter devices

# Run with verbose output
flutter run -v

# Run on specific device
flutter run -d <device-id>

# Run tests
flutter test

# Format code
dart format .

# Analyze code
dart analyze

# Get all package info
flutter pub outdated
```

---

## Next Steps After Setup

Once Firebase is configured and working:

1. ✅ Create Firestore collections in Firebase Console
2. ✅ Implement authentication in your pages
3. ✅ Test data read/write operations
4. ✅ Set up security rules
5. ✅ Deploy to test devices

---

## Common Issues & Solutions

| Issue | Command to Fix |
|-------|----------------|
| Dependencies not found | `flutter pub get` |
| Build fails | `flutter clean && flutter pub get` |
| Firebase options missing | `flutterfire configure` |
| gradle issues | `flutter clean && flutter pub get` |
| Lock file outdated | `rm pubspec.lock && flutter pub get` |

---

**You're ready to start building with Firebase!** 🚀

