# 🔥 Firebase Setup Guide for Trekkie

This guide will help you set up Firebase for the Trekkie app to enable multi-tenant authentication and cloud data sync.

## Prerequisites

- A Google account
- Flutter SDK installed
- Basic understanding of Firebase

## Step 1: Create a Firebase Project

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Click **"Add project"** or **"Create a project"**
3. Enter your project name (e.g., "trekkie" or "star-trek-tracker")
4. (Optional) Enable Google Analytics for your project
5. Click **"Create project"** and wait for it to be created

## Step 2: Register Your Apps

### For Android

1. In the Firebase Console, click the **Android** icon to add an Android app
2. Enter your Android package name: `com.example.trekkie`
   - You can find this in `android/app/build.gradle.kts` under `applicationId`
3. (Optional) Enter app nickname: "Trekkie Android"
4. (Optional) Enter SHA-1 certificate (required for Google Sign-In)
   - Get it by running: `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android`
5. Click **"Register app"**
6. Download the `google-services.json` file
7. Move `google-services.json` to `android/app/` directory

### For Web

1. In the Firebase Console, click the **Web** icon (</>) to add a web app
2. Enter app nickname: "Trekkie Web"
3. Check **"Also set up Firebase Hosting"** (optional)
4. Click **"Register app"**
5. Copy the Firebase configuration object (you'll need this in the next step)

## Step 3: Configure Firebase in Your App

### Update `lib/main.dart`

Replace the placeholder Firebase configuration in `main.dart` with your actual values:

```dart
await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: 'YOUR_ACTUAL_API_KEY',
    appId: 'YOUR_ACTUAL_APP_ID',
    messagingSenderId: 'YOUR_ACTUAL_MESSAGING_SENDER_ID',
    projectId: 'YOUR_ACTUAL_PROJECT_ID',
    authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  ),
);
```

### Update `web/index.html`

Replace the Firebase configuration in `web/index.html`:

```javascript
const firebaseConfig = {
  apiKey: "YOUR_ACTUAL_API_KEY",
  authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
  projectId: "YOUR_ACTUAL_PROJECT_ID",
  storageBucket: "YOUR_PROJECT_ID.appspot.com",
  messagingSenderId: "YOUR_ACTUAL_MESSAGING_SENDER_ID",
  appId: "YOUR_ACTUAL_APP_ID"
};
```

## Step 4: Enable Authentication Methods

1. In the Firebase Console, go to **Authentication** → **Sign-in method**
2. Click on **Email/Password**
   - Enable it
   - Click **Save**
3. Click on **Google**
   - Enable it
   - Enter a public-facing name for your project (e.g., "Trekkie")
   - Enter a support email
   - Click **Save**

## Step 5: Set Up Cloud Firestore

1. In the Firebase Console, go to **Firestore Database**
2. Click **"Create database"**
3. Choose a location for your database (pick one close to your users)
4. Start in **production mode** (we'll add security rules next)
5. Click **"Enable"**

### Add Security Rules

Go to the **Rules** tab in Firestore and replace with these secure rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // User data - users can only read/write their own data
    match /userData/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Prevent all other access
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

Click **"Publish"** to save the rules.

## Step 6: Configure Google Sign-In (Android)

### Get SHA-1 Certificate Fingerprint

For debug builds:
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

For release builds:
```bash
keytool -list -v -keystore /path/to/your/keystore.jks -alias your-alias-name
```

### Add SHA-1 to Firebase

1. In Firebase Console, go to **Project Settings**
2. Scroll down to **Your apps** → **Android app**
3. Click **"Add fingerprint"**
4. Paste your SHA-1 fingerprint
5. Click **"Save"**

## Step 7: Install Dependencies

Run the following command to install all Firebase dependencies:

```bash
flutter pub get
```

## Step 8: Test Your Setup

### Test Android App

```bash
flutter run -d android
```

### Test Web App

```bash
flutter run -d chrome
```

## Step 9: Build for Production

### Android

```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### Web

```bash
flutter build web --release
```

The web build will be in `build/web/` directory.

## Firestore Data Structure

The app stores user data in the following structure:

```
userData/
  {userId}/
    createdAt: timestamp
    watchedEpisodes:
      {episodeId}:
        watched: true
        watchedAt: timestamp
    favoriteEpisodes:
      {episodeId}:
        favorite: true
        favoritedAt: timestamp
    watchedMovies:
      {movieId}:
        watched: true
        watchedAt: timestamp
    favoriteMovies:
      {movieId}:
        favorite: true
        favoritedAt: timestamp
```

## Troubleshooting

### Google Sign-In not working on Android

- Make sure you've added the SHA-1 fingerprint in Firebase Console
- Verify `google-services.json` is in `android/app/` directory
- Check that the package name matches in both Firebase and `build.gradle.kts`

### Firebase not initializing

- Double-check all configuration values match your Firebase project
- Make sure you've run `flutter pub get`
- Try `flutter clean` and rebuild

### Firestore permission denied

- Verify your security rules are set correctly
- Make sure user is authenticated before accessing Firestore
- Check that the user ID matches in the rules

## Security Best Practices

1. **Never commit Firebase config with real values to public repositories**
   - Consider using environment variables or Firebase App Check
2. **Use Firebase Security Rules** to protect your data
3. **Enable App Check** for additional security in production
4. **Regularly review authentication logs** for suspicious activity
5. **Set up budget alerts** in Google Cloud Console to avoid unexpected costs

## Firebase Console URLs

- **Firebase Console**: https://console.firebase.google.com/
- **Your Project**: https://console.firebase.google.com/project/YOUR_PROJECT_ID/
- **Authentication**: https://console.firebase.google.com/project/YOUR_PROJECT_ID/authentication
- **Firestore**: https://console.firebase.google.com/project/YOUR_PROJECT_ID/firestore

## Additional Resources

- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Authentication Docs](https://firebase.google.com/docs/auth)
- [Cloud Firestore Docs](https://firebase.google.com/docs/firestore)
- [Firebase Security Rules Guide](https://firebase.google.com/docs/rules)

## Support

If you encounter issues:
1. Check the [FlutterFire GitHub Issues](https://github.com/firebase/flutterfire/issues)
2. Review [Firebase Documentation](https://firebase.google.com/docs)
3. Ask on [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter+firebase)

---

**Live long and prosper!** 🖖
