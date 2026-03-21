# Firebase Setup Guide for Exam Seating Arrangement App

## ✅ Completed Setup Steps

Your teammate has already:
1. Created a Firebase project: **seating-arrangement-73a5d**
2. Added you as a collaborator with Editor access
3. Generated and placed the `google-services.json` file in your Android app

## 📋 Steps You Need to Complete

### **Step 1: Fix Windows Developer Mode** (For Flutter builds)
1. Open Windows Settings (or run: `start ms-settings:developers`)
2. Turn on **Developer Mode**
3. This enables symlink support needed by Flutter plugins

### **Step 2: Set Up iOS Firebase Configuration** (If building for iOS)

Run FlutterFire CLI to generate iOS configuration:
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Follow the prompts:
- Select your Firebase project: **seating-arrangement-73a5d**
- Select platforms: iOS, Android
- This will generate `firebase_options.dart` automatically

### **Step 3: Verify Your Setup**

Check that these files exist:
- ✅ `android/app/google-services.json` (already present)
- ✅ `lib/firebase_options.dart` (should be generated)
- ✅ Updated `pubspec.yaml` with Firebase dependencies
- ✅ Updated Gradle files with Google Services plugin

### **Step 4: Test Firebase Connection**

Run your app:
```bash
flutter run
```

The Firebase initialization in `main.dart` will automatically connect your app to the Firebase project.

---

## 🔥 Firebase Services Available

Your project now has access to:

### **1. Firebase Authentication**
```dart
import 'package:firebase_auth/firebase_auth.dart';

// Sign up
await FirebaseAuth.instance.createUserWithEmailAndPassword(
  email: 'user@example.com',
  password: 'password123',
);

// Sign in
await FirebaseAuth.instance.signInWithEmailAndPassword(
  email: 'user@example.com',
  password: 'password123',
);

// Get current user
User? user = FirebaseAuth.instance.currentUser;
```

### **2. Cloud Firestore (Database)**
```dart
import 'package:cloud_firestore/cloud_firestore.dart';

final db = FirebaseFirestore.instance;

// Add document
await db.collection('exams').add({
  'name': 'Mathematics Final',
  'date': DateTime.now(),
});

// Query documents
final exams = await db.collection('exams').get();

// Listen to real-time updates
db.collection('exams').snapshots().listen((snapshot) {
  for (var doc in snapshot.docs) {
    print(doc.data());
  }
});
```

### **3. Firebase Storage (File Storage)**
```dart
import 'package:firebase_storage/firebase_storage.dart';

final storage = FirebaseStorage.instance;

// Upload file
final ref = storage.ref('hall_tickets').child('student_001.pdf');
await ref.putFile(File('path/to/file.pdf'));

// Download file
final url = await storage.ref('hall_tickets').child('student_001.pdf').getDownloadURL();
```

---

## 📁 Project Files Updated

### Modified:
- `pubspec.yaml` - Added Firebase dependencies
- `android/build.gradle.kts` - Added Google Services plugin
- `android/app/build.gradle.kts` - Applied Google Services plugin
- `lib/main.dart` - Added Firebase initialization

### To Generate:
- Run `flutterfire configure` to create `lib/firebase_options.dart`

---

## 🚀 Next Steps for Your Features

### For **Admin Dashboard**:
- Store admin users in Firebase Auth
- Store exam/seating data in Firestore
- Send notifications via Firebase Cloud Messaging

### For **Student Features**:
- Student authentication
- Seat allocation data in Firestore
- Hall tickets in Firebase Storage or generated from data

### For **Invigilator Features**:
- Invigilator authentication
- Real-time updates of student attendance

### For **Notifications**:
- Implement Firebase Cloud Messaging (FCM)
- Send push notifications to users

---

## ⚠️ Important Notes

1. **Never commit API keys**: The `google-services.json` contains your API key
   - It's already in your `.gitignore` (if properly configured)
   - Don't share it publicly

2. **Firestore Security Rules**: Set up proper security rules in Firebase Console
   - Go to Firestore → Rules tab
   - Define who can read/write data

3. **Firebase Console**: Access your project at:
   - https://console.firebase.google.com/
   - Select project: `seating-arrangement-73a5d`

---

## 🐛 Troubleshooting

### Issue: "firebase_options.dart not found"
**Solution**: Run `flutterfire configure`

### Issue: "Google Services plugin not found"
**Solution**: Ensure you've applied the plugin in both `build.gradle.kts` files

### Issue: "Symlink error on Windows"
**Solution**: Enable Developer Mode in Windows Settings

### Issue: Build fails with "Module not specified"
**Solution**: Clean and rebuild:
```bash
flutter clean
flutter pub get
flutter run
```

---

## 📞 Useful Resources

- [Firebase Documentation](https://firebase.flutter.dev/)
- [Firestore Guide](https://firebase.google.com/docs/firestore)
- [Firebase Auth](https://firebase.google.com/docs/auth)
- [Flutter Firebase Integration](https://cloud.google.com/docs/flutter)

