## 🔒 Firebase Setup - Security Guide

### ⚠️ IMPORTANT: API Keys Must NEVER Be Committed to GitHub

Your Firebase API keys are automatically generated in `lib/firebase_options.dart`. 
**This file should NEVER be committed to version control.**

### Setup Instructions

#### 1️⃣ **Initial Setup (First Time)**

```bash
# Install FlutterFire CLI if not already installed
dart pub global activate flutterfire_cli

# Configure Firebase for all platforms
flutterfire configure

# This will:
# - Detect your Flutter platforms
# - Ask which Firebase project to use
# - Generate new firebase_options.dart automatically
```

#### 2️⃣ **After Cloning from GitHub**

If you cloned this repo and don't have `firebase_options.dart`:

```bash
# Re-generate it with YOUR Firebase project
flutterfire configure

# Or if you want to use an existing Firebase project:
flutterfire configure --project=your-firebase-project-id
```

#### 3️⃣ **Verify .gitignore Protection**

Check that these lines are in `.gitignore`:
```
firebase_options.dart
google-services.json
.env
```

This prevents accidental commits of sensitive files.

#### 4️⃣ **Running the App**

```bash
flutter pub get
flutter run
```

### 🔐 Security Best Practices

✅ **DO:**
- Keep `firebase_options.dart` in your `.gitignore`
- Use `flutterfire configure` to generate keys for YOUR project
- Each developer/device gets their own keys
- Rotate API keys regularly in Firebase Console

❌ **DON'T:**
- Commit `firebase_options.dart` to GitHub
- Share API keys via Slack, email, or chat
- Use hardcoded keys in the code
- Leave keys in public repositories

### 📋 What If Keys Were Already Exposed?

If you accidentally committed API keys:

1. **Revoke the keys immediately** in Google Cloud Console:
   - Go to APIs & Services → Credentials
   - Delete exposed API keys
   - Google will suspend any abused APIs

2. **Remove from git history**:
   ```bash
   git rm --cached lib/firebase_options.dart
   git commit -m "SECURITY: Remove exposed API keys"
   git push origin main
   ```

3. **Regenerate new keys**:
   ```bash
   flutterfire configure
   ```

4. **Submit appeal** to Google Cloud if your API was suspended

### 📚 Reference Files

- `firebase_options.template.dart` - Example template
- `.gitignore` - Includes firebase_options.dart
- `firebase.json` - Firebase configuration (safe to commit)

### ❓ Questions?

Refer to [Firebase Documentation](https://firebase.flutter.dev)

