# Google Sign-In Implementation Checklist

## ✅ Code Implementation (DONE)

- [x] Add `google_sign_in` dependency di pubspec.yaml
- [x] Create `google_complete_profile_page.dart`
- [x] Update `auth_api.dart` dengan 3 new methods:
  - [x] `signInWithGoogle()`
  - [x] `completeGoogleRegistration()`
  - [x] `signOutGoogle()`
- [x] Update `onboarding_page.dart`:
  - [x] Add `_handleGoogleSignIn()` method
  - [x] Implement Google button functionality
  - [x] Add loading state
- [x] Update `app_router.dart`:
  - [x] Add import
  - [x] Add new route `/google-complete-profile`
  - [x] Update redirect logic

---

## 🔧 Android Setup (TODO)

### Step 1: Generate Signing Certificate
- [ ] Buka Terminal di folder `android/`
- [ ] Run: `./gradlew signingReport`
- [ ] Copy **SHA1** fingerprint

### Step 2: Firebase Console Setup
- [ ] Go to https://console.firebase.google.com/
- [ ] Create new project atau gunakan existing
- [ ] Enable Firebase Authentication
- [ ] Enable Google sign-in method

### Step 3: Google Cloud Console
- [ ] Go to https://console.cloud.google.com/
- [ ] Create OAuth 2.0 Client ID (Android)
- [ ] Add SHA1 fingerprint dari step 1
- [ ] Download credentials JSON

### Step 4: Update build.gradle
- [ ] Update `android/build.gradle.kts`:
  ```kotlin
  buildscript {
    dependencies {
      classpath 'com.google.gms:google-services:4.3.15'
    }
  }
  ```

- [ ] Update `android/app/build.gradle.kts`:
  ```kotlin
  apply plugin: 'com.google.gms.google-services'
  
  dependencies {
    implementation 'com.google.android.gms:play-services-auth:21.0.0'
  }
  ```

### Step 5: Update AndroidManifest.xml
- [ ] Add permissions (jika belum ada):
  ```xml
  <uses-permission android:name="android.permission.INTERNET" />
  ```

---

## 🍎 iOS Setup (TODO)

### Step 1: Get iOS Client ID
- [ ] Go to Google Cloud Console
- [ ] Create OAuth 2.0 Client ID (iOS)
- [ ] Copy Bundle ID dari Info.plist
- [ ] Download GoogleService-Info.plist

### Step 2: Add GoogleService-Info.plist
- [ ] Download GoogleService-Info.plist dari Firebase
- [ ] Copy ke `ios/Runner/`
- [ ] In Xcode:
  - [ ] Right-click `ios/Runner` folder
  - [ ] Select "Add Files to Runner"
  - [ ] Choose GoogleService-Info.plist
  - [ ] Check "Copy items if needed"
  - [ ] Make sure it's added to Runner target

### Step 3: Update Info.plist
- [ ] Open `ios/Runner/Info.plist`
- [ ] Add Google Client ID:
  ```xml
  <key>GIDClientID</key>
  <string>YOUR_IOS_CLIENT_ID.apps.googleusercontent.com</string>
  ```

- [ ] Add URL Scheme:
  ```xml
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

### Step 4: Update Podfile (if needed)
- [ ] Open `ios/Podfile`
- [ ] Ensure no pod conflicts
- [ ] Run: `cd ios && pod update && cd ..`

---

## 🗄️ Database Setup (TODO)

- [ ] Check database struktur untuk tabel `users`
- [ ] Ensure columns exist:
  - [ ] `id` (uuid, primary key)
  - [ ] `username` (varchar, UNIQUE NOT NULL)
  - [ ] `email` (varchar)
  - [ ] `phone` (varchar)
  - [ ] `bio` (varchar, nullable)
  - [ ] `avatarUrl` (varchar, nullable)
  - [ ] `created_at` (timestamp)

### Migration (jika ada missing columns):
```sql
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS username varchar UNIQUE NOT NULL;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS email varchar;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS phone varchar;
```

---

## 🔐 Environment Variables (TODO)

- [ ] Create atau update `.env` file di root project:
  ```
  SUPABASE_URL=https://xxxx.supabase.co
  SUPABASE_ANON_KEY=xxxx
  GOOGLE_WEB_CLIENT_ID=xxxx.apps.googleusercontent.com
  ```

- [ ] Add `.env` ke `.gitignore` (jangan commit sensitive data)

---

## 🧪 Testing (TODO)

### Pre-Test
- [ ] Run `flutter clean`
- [ ] Run `flutter pub get`
- [ ] All setup steps di atas sudah done

### Android Testing
- [ ] Build APK: `flutter build apk`
- [ ] atau Run di emulator: `flutter run -d android`
- [ ] Test complete flow:
  - [ ] Tap "Sign in with google"
  - [ ] Google popup muncul
  - [ ] Complete profile page muncul dengan email pre-filled
  - [ ] Isi username + phone
  - [ ] Tap complete, navigate ke home
  - [ ] Check database, data tersimpan

### iOS Testing
- [ ] Run di simulator: `flutter run -d ios`
- [ ] Same testing steps seperti Android

### Error Testing
- [ ] Test username already exists
- [ ] Test invalid phone number
- [ ] Test cancel Google sign-in
- [ ] Test network error

---

## 📱 Deployment (TODO - after testing)

- [ ] Code review selesai
- [ ] All tests passed
- [ ] Update README.md dengan feature baru
- [ ] Commit dengan message: `feat: add Google Sign-In authentication`
- [ ] Push ke repository
- [ ] Create release notes
- [ ] Update version di pubspec.yaml

---

## 📋 Quick Reference

### Important Files Modified/Created:
```
✏️  pubspec.yaml
✏️  lib/features/auth/data/datasources/auth_api.dart
✏️  lib/features/auth/presentation/pages/onboarding_page.dart
✏️  lib/router/app_router.dart
✨ lib/features/auth/presentation/pages/google_complete_profile_page.dart (NEW)
```

### Documentation Files:
```
📄 GOOGLE_SIGNIN_SETUP.md (Setup guide)
📄 GOOGLE_SIGNIN_IMPLEMENTATION.md (Implementation summary)
📄 GOOGLE_SIGNIN_TESTING.md (Testing guide)
📄 GOOGLE_SIGNIN_CHECKLIST.md (This file)
```

---

## ⏱️ Estimated Time

- Android Setup: **15-20 minutes**
- iOS Setup: **15-20 minutes**
- Testing: **20-30 minutes**
- Total: **1-1.5 hours**

---

## 🚨 Important Reminders

1. **Don't commit credentials**: `.env` files harus di `.gitignore`
2. **Use test accounts first**: Test dengan dummy Google account sebelum production
3. **Database backup**: Backup database sebelum run migration
4. **Check constraints**: Verify unique constraints di database
5. **Monitor logs**: Check error logs setelah deployment

---

## 📞 Support

Jika ada error:
1. Check GOOGLE_SIGNIN_SETUP.md troubleshooting section
2. Check GOOGLE_SIGNIN_TESTING.md common issues
3. Check console logs: `flutter run -v`
4. Check Firebase/Google Cloud Console logs

---

**Status: Ready for Setup Phase** ✅

Sekarang lanjut ke Android & iOS setup!
