# 🔧 Fix: "Incorrect Credentials, Malformed or Expired" Error

## ❌ The Problem

You added credentials to **Firestore Database** only, but Firebase login requires:
1. **Firebase Authentication** (stores email/password)
2. **Firestore Database** (stores user data like role, name)

**You need BOTH for login to work!**

## ✅ Solution: Run the User Setup Script

I've created a setup script that will properly create test users in both Firebase Authentication AND Firestore.

### Step 1: Run the Setup Script

```powershell
cd C:\Users\ardhr\Desktop\minipro_13\miniprj_2
flutter run lib/setup_test_users.dart
```

### Step 2: Click "CREATE TEST USERS" Button

The app will create these test accounts:
- **Admin:** admin@test.com / admin1234
- **Student:** student@test.com / student1234
- **Invigilator:** invigilator@test.com / invig1234

### Step 3: Test Login

After setup is complete:
1. Close the setup app
2. Run your main app: `flutter run`
3. Try logging in with: **admin@test.com** / **admin1234**

---

## 🎯 What the Script Does

1. ✅ Creates user in **Firebase Authentication** (email/password)
2. ✅ Creates user document in **Firestore** (role, name, etc.)
3. ✅ Handles existing users (won't crash if already created)
4. ✅ Shows detailed logs of the process

---

## 🔍 Understanding Firebase Structure

### Firebase Authentication (Login Credentials)
```
admin@test.com
  ├── UID: abc123xyz
  └── Password: admin1234 (hashed)
```

### Firestore Database (User Data)
```
users/
  └── abc123xyz/
      ├── email: "admin@test.com"
      ├── role: "admin"
      ├── name: "Admin User"
      └── createdAt: timestamp
```

**Both are required for login!**

---

## 🛠️ Alternative: Manual Setup (Firebase Console)

If you prefer to create users manually:

### 1. Firebase Authentication Console
1. Go to: https://console.firebase.google.com
2. Select your project
3. Click "Authentication" → "Users" tab
4. Click "Add User"
5. Enter email: `admin@test.com`
6. Enter password: `admin1234`
7. Click "Add User"
8. **Copy the UID** (e.g., `abc123xyz`)

### 2. Firestore Console
1. Click "Firestore Database"
2. Create collection: `users`
3. Add document with ID = **the UID you copied**
4. Add fields:
   - `email`: "admin@test.com"
   - `role`: "admin"
   - `name`: "Admin User"
   - `createdAt`: timestamp (current time)

---

## 🚨 Common Mistakes

1. ❌ Only adding to Firestore → Won't authenticate
2. ❌ Only adding to Authentication → Will authenticate but crash when fetching role
3. ❌ Mismatched UIDs → User data not found
4. ✅ **Both with matching UIDs** → Works perfectly!

---

## 📝 Testing After Setup

Try these scenarios:

### ✅ Should Work:
- Login as admin with admin@test.com / admin1234
- Login as student with student@test.com / student1234
- Login as invigilator with invigilator@test.com / invig1234

### ❌ Should Fail Properly:
- Wrong password → "Incorrect password"
- Non-existent email → "No user found with this email"
- Wrong role selection → "Access denied for this role"

---

## 🎉 Next Steps

After users are created:
1. Login should work within 1-2 seconds
2. You can create more users using the `createUser()` method in AuthService
3. Or use the setup script again with different credentials

Need more users? Edit `lib/setup_test_users.dart` and add to the `testUsers` list!

