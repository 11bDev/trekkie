# 🚀 Quick Start Guide - Trekkie v2.0

## Prerequisites
- Flutter SDK 3.8.1+
- Firebase account
- Android Studio (for Android)
- Chrome/Edge (for Web)

## 5-Minute Setup

### 1. Clone & Install
```bash
git clone https://github.com/11bDev/trekkie.git
cd trekkie
flutter pub get
```

### 2. Create Firebase Project
1. Go to https://console.firebase.google.com/
2. Click "Create Project"
3. Name it (e.g., "trekkie")
4. Complete the wizard

### 3. Add Android App
1. Click Android icon in Firebase Console
2. Package name: `com.example.trekkie`
3. Download `google-services.json`
4. Place in `android/app/`

### 4. Add Web App
1. Click Web icon (</>) in Firebase Console
2. Register app
3. Copy the config object

### 5. Update Config Files

**lib/main.dart** (line ~17):
```dart
options: const FirebaseOptions(
  apiKey: 'YOUR_API_KEY',                    // ← Replace
  appId: 'YOUR_APP_ID',                      // ← Replace
  messagingSenderId: 'YOUR_SENDER_ID',       // ← Replace
  projectId: 'YOUR_PROJECT_ID',              // ← Replace
  authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
  storageBucket: 'YOUR_PROJECT_ID.appspot.com',
),
```

**web/index.html** (line ~78):
```javascript
const firebaseConfig = {
  apiKey: "YOUR_API_KEY",                    // ← Replace
  authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
  projectId: "YOUR_PROJECT_ID",              // ← Replace
  storageBucket: "YOUR_PROJECT_ID.appspot.com",
  messagingSenderId: "YOUR_SENDER_ID",       // ← Replace
  appId: "YOUR_APP_ID"                       // ← Replace
};
```

### 6. Enable Authentication
1. Firebase Console → Authentication
2. Enable "Email/Password"
3. Enable "Google"

### 7. Create Firestore Database
1. Firebase Console → Firestore
2. Create database (production mode)
3. Rules tab → paste this:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /userData/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 8. Run!
```bash
# Android
flutter run -d android

# Web
flutter run -d chrome
```

## Common Issues

**"Command not found: flutter"**
- Install Flutter SDK: https://flutter.dev/docs/get-started/install

**"Firebase not initialized"**
- Check config values in `main.dart` and `web/index.html`
- Make sure you replaced all placeholders

**"Permission denied" in Firestore**
- Check security rules are deployed
- Verify user is signed in

**Google Sign-In not working**
- Add SHA-1 fingerprint in Firebase Console
- For debug: `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android`

## Testing Accounts

Create test accounts:
```
Email: test@trekkie.com
Password: LiveLongAndProsper123
```

## Need Help?

📖 Full Setup Guide: [FIREBASE_SETUP.md](FIREBASE_SETUP.md)  
🔄 Migration Info: [MIGRATION_SUMMARY.md](MIGRATION_SUMMARY.md)  
📝 Changelog: [CHANGELOG.md](CHANGELOG.md)  
🐛 Issues: https://github.com/11bDev/trekkie/issues

**Live long and prosper!** 🖖
