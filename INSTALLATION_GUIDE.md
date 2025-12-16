# 🚀 Installation Guide - Google Sign-In for PhotoKart

**Status**: Code implementation ✅ DONE | Setup & Testing ⏳ TODO

---

## 📖 How to Use This Guide

This guide walks you through everything after code implementation. Follow it step-by-step.

**Estimated Time**: 1.5 - 2.5 hours

---

## ✅ Prerequisites

Make sure you have:
- [ ] Flutter SDK installed
- [ ] Android development setup
- [ ] iOS development setup (if testing on iOS)
- [ ] Google account (for testing)
- [ ] Supabase project created
- [ ] Supabase database setup with users table

---

## 🔧 Step 1: Update Dependencies

### Run:
```bash
cd c:/FILEEEE/Semester\ 5/Tekber/tekberganjil/PhotoKart

flutter clean
flutter pub get
```

### Expected Output:
```
✓ Dependencies resolved
✓ pub get completed
```

**If error**: Run again or check Flutter installation

---

## 🌐 Step 2: Get Google OAuth Credentials

### 2.1 Create Google Cloud Project

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Click "Select a Project" → "New Project"
3. Project name: `PhotoKart` (or your name)
4. Click "Create"
5. Wait for project to be created

### 2.2 Enable OAuth Consent Screen

1. Go to "APIs & Services" → "OAuth consent screen"
2. Choose "External" user type
3. Click "Create"
4. Fill form:
   - App name: `PhotoKart`
   - User support email: your email
   - Developer contact: your email
5. Click "Save and Continue"

### 2.3 Create OAuth Client ID

1. Go to "APIs & Services" → "Credentials"
2. Click "+ Create Credentials" → "OAuth client ID"
3. Choose "Android" first:
   - Name: `PhotoKart Android`
   - Package name: check `android/app/build.gradle.kts` for `applicationId`
   - SHA1: from step below
   - Click "Create"
4. Then create "iOS":
   - Name: `PhotoKart iOS`
   - Bundle ID: check `ios/Runner/Info.plist` or `ios/Runner.xcodeproj`
   - App store ID: leave empty (for dev)
   - Team ID: leave empty (for dev)
   - Click "Create"

---

## 📱 Step 3: Android Setup

### 3.1 Get SHA1 Fingerprint

```bash
cd android
./gradlew signingReport
```

**Output** (look for):
```
Variant: debug
Config: debug
Store: ~/.android/debug.keystore
Alias: AndroidDebugKey
MD5: ...
SHA1: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX  ← COPY THIS!
SHA256: ...
```

Copy the SHA1 value (without colons).

### 3.2 Add to Google Cloud

1. Go back to Google Cloud Console
2. Click your Android Client ID
3. Add to "SHA1 certificate fingerprints"
4. Click "Update"

### 3.3 Update build.gradle Files

**File**: `android/build.gradle.kts`

Add in `buildscript` → `dependencies`:
```kotlin
classpath 'com.google.gms:google-services:4.3.15'
```

**File**: `android/app/build.gradle.kts`

Add at the end:
```kotlin
apply plugin: 'com.google.gms.google-services'

dependencies {
    implementation 'com.google.android.gms:play-services-auth:21.0.0'
}
```

### 3.4 Verify

```bash
cd android
./gradlew clean build
```

Expected: Build successful

---

## 🍎 Step 4: iOS Setup

### 4.1 Get GoogleService-Info.plist

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create new project or use existing
3. Add iOS app:
   - iOS Bundle ID: from Info.plist
   - Click "Register app"
4. Download `GoogleService-Info.plist`

### 4.2 Add to Xcode Project

1. Open `ios/Runner.xcworkspace` (NOT .xcodeproj)
2. Right-click `Runner` folder
3. Select "Add Files to Runner"
4. Choose downloaded `GoogleService-Info.plist`
5. Make sure it's added to Runner target

### 4.3 Update Info.plist

**File**: `ios/Runner/Info.plist`

Add before closing `</dict>`:
```xml
<key>GIDClientID</key>
<string>YOUR_IOS_CLIENT_ID.apps.googleusercontent.com</string>

<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>com.googleusercontent.apps.YOUR_IOS_CLIENT_ID</string>
    </array>
  </dict>
</array>
```

Replace `YOUR_IOS_CLIENT_ID` with your actual Client ID.

### 4.4 Update Podfile (if needed)

**File**: `ios/Podfile`

Sometimes needs to be updated. If you get pod errors:

```bash
cd ios
pod update
cd ..
```

---

## 🔑 Step 5: Environment Variables

### Create .env file

Create file: `.env` in root project

```
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
GOOGLE_WEB_CLIENT_ID=your-web-client-id.apps.googleusercontent.com
```

Get values from:
- **SUPABASE_URL & ANON_KEY**: Supabase project settings
- **GOOGLE_WEB_CLIENT_ID**: Google Cloud Console

### Add to .gitignore

Make sure `.env` is in `.gitignore` (don't commit credentials!)

---

## 📲 Step 6: Test Android

### 6.1 Connect Device/Emulator

```bash
flutter devices
```

You should see an Android device listed.

### 6.2 Run App

```bash
flutter run -d android
```

Wait for app to build and start.

### 6.3 Test Flow

1. App opens with Onboarding
2. Swipe to Page 3 (or tap Next twice)
3. Tap "Sign in with google"
4. Google popup appears
5. Choose your test account
6. After auth, "Complete Your Profile" page opens
7. Email should be pre-filled
8. Fill username (e.g., `testuser123`)
9. Fill phone (e.g., `081234567890`)
10. Tap "Complete Profile"
11. Should navigate to home page
12. Check Supabase database - should have new user

### If Error:
```bash
flutter run -d android -v
```

Check error logs and see [GOOGLE_SIGNIN_TESTING.md](GOOGLE_SIGNIN_TESTING.md) for solutions.

---

## 🍎 Step 7: Test iOS (Optional)

### 7.1 Connect Device/Simulator

```bash
flutter devices
```

You should see an iOS device listed.

### 7.2 Run App

```bash
flutter run -d ios
```

### 7.3 Test Flow

Same as Android step 6.3.

### If Error:
- Check Info.plist
- Check GoogleService-Info.plist
- Run `cd ios && pod deintegrate && pod install && cd ..`

---

## ✅ Step 8: Verify Database

### Check Data

Open Supabase Dashboard → SQL Editor, run:

```sql
SELECT * FROM public.users 
ORDER BY created_at DESC 
LIMIT 5;
```

You should see your test user with:
- username: testuser123
- email: your-google-email
- phone: 081234567890

---

## 🧪 Step 9: Run Complete Tests

See [GOOGLE_SIGNIN_TESTING.md](GOOGLE_SIGNIN_TESTING.md) for:
- All test cases
- Error scenarios
- Debug tips

---

## 🎯 Step 10: Deployment

When ready for production:

1. Update version in `pubspec.yaml`
2. Create release build: `flutter build apk` (Android)
3. Test thoroughly
4. Deploy to Play Store / App Store
5. Monitor error logs

---

## ✨ Checklist

```
Step 1: Update Dependencies
- [ ] flutter clean
- [ ] flutter pub get

Step 2: Get Google OAuth Credentials
- [ ] Google Cloud Console setup
- [ ] OAuth Client IDs created
- [ ] Credentials downloaded

Step 3: Android Setup
- [ ] SHA1 fingerprint obtained
- [ ] build.gradle files updated
- [ ] Android build successful

Step 4: iOS Setup
- [ ] GoogleService-Info.plist added
- [ ] Info.plist updated
- [ ] iOS build successful

Step 5: Environment Variables
- [ ] .env file created
- [ ] Credentials added
- [ ] .gitignore includes .env

Step 6: Android Testing
- [ ] App runs on Android
- [ ] Google button works
- [ ] Complete profile flow works
- [ ] Data saves to database

Step 7: iOS Testing (if needed)
- [ ] App runs on iOS
- [ ] Google button works
- [ ] Complete profile flow works
- [ ] Data saves to database

Step 8: Database Verification
- [ ] New user in database
- [ ] All fields filled correctly

Step 9: Full Testing
- [ ] All test cases passed
- [ ] Error scenarios handled
- [ ] No crashes

Step 10: Ready for Deployment
- [ ] Code committed
- [ ] Documentation updated
- [ ] Ready for production
```

---

## 🚨 Common Issues & Quick Fixes

| Issue | Fix |
|-------|-----|
| "Flutter not found" | Add Flutter to PATH |
| "gradle error" | Run `./gradlew clean` |
| "Pod error" | Run `cd ios && pod update && cd ..` |
| "Google popup doesn't show" | Check SHA1 / Client ID |
| "App crashes on Google button" | Check dependencies installed |
| "Username already taken" | Normal! Choose different username |
| "Database empty" | Check Supabase connection |

---

## 📞 Need Help?

1. Read [GOOGLE_SIGNIN_SETUP.md](GOOGLE_SIGNIN_SETUP.md) for detailed setup
2. Read [GOOGLE_SIGNIN_TESTING.md](GOOGLE_SIGNIN_TESTING.md) for testing help
3. Check troubleshooting sections in docs
4. Run with verbose: `flutter run -v`

---

## 🎉 Success!

After completing all steps, you should have:

✅ Google Sign-In working on Android
✅ Google Sign-In working on iOS
✅ Email auto-filled from Google
✅ User fills username + phone
✅ Data saved to database
✅ User logged in & on home page

---

## 📝 Final Notes

- **Don't skip steps** - follow in order
- **Take time with setup** - credentials are important
- **Test thoroughly** - before deploying
- **Keep documentation** - for future reference
- **Monitor errors** - check logs if issues arise

---

**You're all set! Follow the steps and you'll have Google Sign-In working! 🚀**

Questions? Check the documentation files - they have detailed answers!
