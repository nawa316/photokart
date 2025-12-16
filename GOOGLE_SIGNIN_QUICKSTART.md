# Google Sign-In Quick Start Guide

## TL;DR - 3 Langkah Cepat

### 1️⃣ Update Dependencies
```bash
flutter pub get
```

### 2️⃣ Setup Google OAuth Credentials
- Buka [Google Cloud Console](https://console.cloud.google.com/)
- Create Android Client ID (SHA1: dari `./gradlew signingReport`)
- Create iOS Client ID
- Download credentials

### 3️⃣ Configure Platform
**Android**: Update `build.gradle` files
**iOS**: Update `Info.plist` + add GoogleService-Info.plist

---

## ✨ What's New?

### New Files Created:
```
lib/features/auth/presentation/pages/google_complete_profile_page.dart
```

### Files Modified:
```
pubspec.yaml
lib/features/auth/data/datasources/auth_api.dart
lib/features/auth/presentation/pages/onboarding_page.dart
lib/router/app_router.dart
```

### Documentation:
```
GOOGLE_SIGNIN_SETUP.md          ← Platform setup guide
GOOGLE_SIGNIN_IMPLEMENTATION.md ← What was implemented
GOOGLE_SIGNIN_TESTING.md        ← How to test
GOOGLE_SIGNIN_CHECKLIST.md      ← Complete checklist
```

---

## 🔄 User Flow

```
Onboarding Page
    ↓
[Tap "Sign in with google"]
    ↓
Google Auth Popup
    ↓
Complete Profile Page (email pre-filled)
    ↓
Fill username + phone
    ↓
[Tap Complete]
    ↓
Home Page (Logged in!) ✅
```

---

## 📲 Key Features

✅ Google authentication
✅ Email auto-filled from Google
✅ Username validation (unique, min 3 chars)
✅ Phone validation (min 10 digits)
✅ Error handling with user feedback
✅ Loading states
✅ Form validation
✅ Responsive UI

---

## 🚀 Next Steps

1. **Read**: [GOOGLE_SIGNIN_CHECKLIST.md](GOOGLE_SIGNIN_CHECKLIST.md)
2. **Follow**: Android setup di [GOOGLE_SIGNIN_SETUP.md](GOOGLE_SIGNIN_SETUP.md)
3. **Follow**: iOS setup di [GOOGLE_SIGNIN_SETUP.md](GOOGLE_SIGNIN_SETUP.md)
4. **Test**: Follow [GOOGLE_SIGNIN_TESTING.md](GOOGLE_SIGNIN_TESTING.md)

---

## 🔧 Quick Commands

```bash
# Update dependencies
flutter pub get

# Clean & rebuild
flutter clean
flutter pub get

# Run on Android
flutter run -d android

# Run on iOS
flutter run -d ios

# Run with verbose logging
flutter run -v

# Build APK for Android
flutter build apk
```

---

## 📝 Code Changes Summary

### auth_api.dart - 3 New Methods

```dart
// Authenticate with Google, return email
Future<String> signInWithGoogle() async { ... }

// Complete registration with username + phone
Future<UserModel> completeGoogleRegistration({
  required String email,
  required String username,
  required String phone,
}) async { ... }

// Sign out
Future<void> signOutGoogle() async { ... }
```

### onboarding_page.dart - Google Button Implementation

```dart
// Handle Google Sign-In
void _handleGoogleSignIn() async {
  try {
    final email = await authApi.signInWithGoogle();
    context.push('/google-complete-profile', extra: email);
  } catch (e) {
    // Show error
  }
}
```

### google_complete_profile_page.dart - New Page

Form dengan fields:
- Email (read-only)
- Username (required, min 3 chars)
- Phone (required, min 10 digits)

---

## ✅ Testing Checklist

After setup:

- [ ] `flutter pub get` successful
- [ ] Android setup complete
- [ ] iOS setup complete
- [ ] Can tap "Sign in with google" button
- [ ] Google popup appears
- [ ] After auth, navigate to complete profile page
- [ ] Email pre-filled correctly
- [ ] Can fill username + phone
- [ ] Form validation works
- [ ] Data saves to database
- [ ] Navigate to home page
- [ ] User logged in correctly

---

## 🆘 Troubleshooting

| Issue | Solution |
|-------|----------|
| Button tidak berfungsi | Run `flutter clean && flutter pub get` |
| Google popup tidak muncul | Check Android/iOS setup |
| Error "12: SignInException" | Verify SHA1 fingerprint |
| "Username already taken" | Normal! User harus pilih username lain |
| App crash | Check console: `flutter run -v` |

---

## 📚 Full Documentation

- **Setup Details**: [GOOGLE_SIGNIN_SETUP.md](GOOGLE_SIGNIN_SETUP.md)
- **Implementation**: [GOOGLE_SIGNIN_IMPLEMENTATION.md](GOOGLE_SIGNIN_IMPLEMENTATION.md)
- **Testing**: [GOOGLE_SIGNIN_TESTING.md](GOOGLE_SIGNIN_TESTING.md)
- **Checklist**: [GOOGLE_SIGNIN_CHECKLIST.md](GOOGLE_SIGNIN_CHECKLIST.md)

---

## 💡 Pro Tips

1. **Use test Google accounts**: Jangan langsung test dengan main account
2. **Check database**: Verify user data tersimpan di Supabase
3. **Monitor logs**: Run with `-v` flag untuk debug
4. **Test error cases**: Coba username yang sudah ada, invalid phone, etc
5. **Backup database**: Sebelum migration, backup data lama

---

## 🎯 Success Criteria

✅ Google Sign-In working on Android
✅ Google Sign-In working on iOS  
✅ User can complete profile
✅ Data saves correctly
✅ User logged in successfully
✅ No crashes or errors
✅ Form validation works

---

## 📞 Need Help?

1. Check the error message carefully
2. Search in troubleshooting sections
3. Check console logs: `flutter run -v`
4. Check Firebase/Google Cloud Console

---

**Happy coding! 🚀**

Setelah selesai, jangan lupa commit:
```bash
git add .
git commit -m "feat: add Google Sign-In authentication"
git push origin main
```
