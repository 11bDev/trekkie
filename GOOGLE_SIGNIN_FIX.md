# Google Sign-In Fix

## Issue
Google Sign-In was failing because the required Google Services plugin was not configured in the Android build files.

## Fixes Applied

### 1. Added Google Services Plugin to Root build.gradle.kts
Added the Google Services classpath dependency to `/android/build.gradle.kts`:
```kotlin
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.google.gms:google-services:4.4.0")
    }
}
```

### 2. Applied Google Services Plugin to App build.gradle.kts
Added the plugin to `/android/app/build.gradle.kts`:
```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")  // <- ADDED THIS
}
```

## Additional Steps Required

### 1. Enable Google Sign-In in Firebase Console
1. Go to: https://console.firebase.google.com/project/trekkie-app/authentication
2. Click on "Sign-in method" tab
3. Enable "Google" provider
4. Set support email to: sgtapple444@gmail.com
5. Save

### 2. Add SHA-1 Fingerprint (Required for Android)

**Option A - Using Gradle (Recommended):**
```bash
cd android
./gradlew signingReport
```
Look for "SHA1" under "Variant: debug" and copy the fingerprint.

**Option B - Using keytool:**
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

**Then add it to Firebase:**
1. Go to: https://console.firebase.google.com/project/trekkie-app/settings/general
2. Scroll to "Your apps" → Select your Android app
3. Click "Add fingerprint"
4. Paste the SHA-1 fingerprint
5. Save

### 3. Rebuild the App
```bash
# Clean build (using FVM)
fvm flutter clean
fvm flutter pub get

# Run on Android
fvm flutter run -d android
```

## Testing Google Sign-In

After completing the above steps:
1. Launch the app on Android device/emulator
2. Click "Sign in with Google" button
3. Select a Google account
4. Verify successful sign-in

## Common Error Messages

### "PlatformException(sign_in_failed)"
- **Cause**: SHA-1 fingerprint not added to Firebase Console
- **Fix**: Follow step 2 above

### "ERROR_INVALID_CREDENTIAL"
- **Cause**: Google Sign-In not enabled in Firebase Console
- **Fix**: Follow step 1 above

### "A network error has occurred"
- **Cause**: google-services.json not properly configured
- **Fix**: Rebuild the app after adding the plugin

### "ApiException: 10"
- **Cause**: OAuth client ID mismatch or SHA-1 not configured
- **Fix**: Ensure SHA-1 is added and wait 5-10 minutes for propagation

## Verification

Run this to verify google-services.json is being processed:
```bash
cd android
./gradlew :app:dependencies | grep firebase
```

You should see Firebase dependencies listed.

## Web Platform

For web, Google Sign-In should work without additional configuration since the client ID is already in `web/index.html`:
```javascript
apiKey: "AIzaSyBZaTHoKg7fErvarVH1LT7AJNH87NzIrVY"
authDomain: "trekkie-app.firebaseapp.com"
projectId: "trekkie-app"
```

Just ensure Google Sign-In is enabled in Firebase Console (step 1 above).
