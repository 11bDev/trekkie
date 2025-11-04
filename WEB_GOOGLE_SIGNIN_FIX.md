# Web Google Sign-In Fix

## Common Web Google Sign-In Errors

### Error: "popup_closed_by_user" or "popup_blocked"
- User closed the popup or browser blocked it
- Not a configuration issue

### Error: "auth/unauthorized-domain"
**This is the most common issue for web Google Sign-In**

## Fix: Add Authorized Domain

### Step 1: Enable Google Sign-In Provider
1. Go to: https://console.firebase.google.com/project/trekkie-app/authentication/providers
2. Click on "Google"
3. Toggle "Enable"
4. Set support email: `sgtapple444@gmail.com`
5. Click "Save"

### Step 2: Add Authorized Domain for localhost
1. Go to: https://console.firebase.google.com/project/trekkie-app/authentication/settings
2. Click the "Authorized domains" tab
3. You should see `localhost` already listed
4. If not, click "Add domain" and add `localhost`

### Step 3: For Production Deployment
When you deploy to Firebase Hosting, the domain will be automatically authorized.
The domain will be: `trekkie-app.web.app` or `trekkie-app.firebaseapp.com`

## Testing Web Google Sign-In

### Method 1: Using Chrome (Recommended)
```bash
cd /home/tim/Projects/trekkie
fvm flutter run -d chrome
```

### Method 2: Using web-server
```bash
cd /home/tim/Projects/trekkie
fvm flutter run -d web-server --web-port=8080
```
Then open: http://localhost:8080

### Method 3: Build and Test
```bash
fvm flutter build web
cd build/web
python3 -m http.server 8000
```
Then open: http://localhost:8000

## Additional OAuth Configuration

If you still get errors, you may need to add the OAuth client to Google Cloud Console:

1. Go to: https://console.cloud.google.com/apis/credentials?project=trekkie-app
2. Find the "Web client (auto created by Google Service)" OAuth 2.0 Client
3. Under "Authorized JavaScript origins", ensure these are added:
   - `http://localhost`
   - `http://localhost:8080`
   - `http://localhost:5000`
4. Under "Authorized redirect URIs", ensure this is added:
   - `http://localhost/__/auth/handler`

## Common Error Messages

### "idpiframe_initialization_failed"
**Cause**: Browser blocking third-party cookies or using incognito mode
**Fix**: 
- Allow third-party cookies for Firebase domains
- Don't use incognito/private mode
- Try a different browser

### "auth/operation-not-allowed"
**Cause**: Google Sign-In not enabled in Firebase Console
**Fix**: Follow Step 1 above

### "auth/popup-blocked"
**Cause**: Browser popup blocker
**Fix**: Allow popups for localhost or use redirect instead of popup

## Using Redirect Instead of Popup (Alternative)

If popups are consistently blocked, you can modify the auth service to use redirect:

In `lib/services/auth_service.dart`, change the Google Sign-In method:
```dart
// Instead of popup (default), use redirect
// This requires additional handling in your app
```

## Verify Configuration

Check your Firebase config in `web/index.html`:
```javascript
apiKey: "AIzaSyBZaTHoKg7fErvarVH1LT7AJNH87NzIrVY"
authDomain: "trekkie-app.firebaseapp.com"
projectId: "trekkie-app"
```

The `authDomain` is critical for Google Sign-In to work properly.

## Running the Fix

1. ✅ Enable Google Sign-In in Firebase Console
2. ✅ Add SHA-1 for Android (already done)
3. ✅ Verify localhost is in authorized domains
4. Run: `fvm flutter run -d chrome`
5. Try signing in with Google

## Still Having Issues?

Open browser console (F12) and look for specific error messages. Common ones:
- Network errors: Check internet connection
- CORS errors: Check authorized domains
- OAuth errors: Check OAuth client configuration in Google Cloud Console
