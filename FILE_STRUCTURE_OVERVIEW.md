# File Structure Overview - Google Sign-In

## 📁 Project Structure After Implementation

```
PhotoKart/
├── lib/
│   ├── features/
│   │   └── auth/
│   │       ├── data/
│   │       │   └── datasources/
│   │       │       └── auth_api.dart ✏️ (MODIFIED)
│   │       │           ├── signInWithGoogle()
│   │       │           ├── completeGoogleRegistration()
│   │       │           └── signOutGoogle()
│   │       └── presentation/
│   │           └── pages/
│   │               ├── onboarding_page.dart ✏️ (MODIFIED)
│   │               │   └── _handleGoogleSignIn()
│   │               ├── login_page.dart (no change)
│   │               ├── register_page.dart (no change)
│   │               ├── email_verification_page.dart (no change)
│   │               └── google_complete_profile_page.dart ✨ (NEW)
│   │                   ├── Email field (read-only)
│   │                   ├── Username field (required)
│   │                   ├── Phone field (required)
│   │                   └── Form validation
│   ├── router/
│   │   └── app_router.dart ✏️ (MODIFIED)
│   │       ├── /google-complete-profile route
│   │       └── Updated redirect logic
│   └── ...
├── pubspec.yaml ✏️ (MODIFIED)
│   └── google_sign_in: ^6.2.1
├── android/
│   ├── build.gradle.kts (TODO: update with Google Services)
│   ├── app/
│   │   └── build.gradle.kts (TODO: add Google Play Services)
│   └── local.properties (TODO: set up)
├── ios/
│   ├── Runner/
│   │   ├── Info.plist (TODO: add Google Client ID)
│   │   └── GoogleService-Info.plist (TODO: add)
│   └── Podfile (might need update)
├── .env (TODO: add Google credentials)
├── .gitignore (should already ignore .env)
├── IMPLEMENTATION_COMPLETE.md ✨ (NEW - Main summary)
├── GOOGLE_SIGNIN_QUICKSTART.md ✨ (NEW - Quick reference)
├── GOOGLE_SIGNIN_CHECKLIST.md ✨ (NEW - Step-by-step)
├── GOOGLE_SIGNIN_SETUP.md ✨ (NEW - Platform setup)
├── GOOGLE_SIGNIN_IMPLEMENTATION.md ✨ (NEW - Technical details)
└── GOOGLE_SIGNIN_TESTING.md ✨ (NEW - Testing guide)
```

---

## 🔄 Data Flow Architecture

```
┌─────────────────────────────────────────────────────┐
│         Presentation Layer (UI)                     │
├─────────────────────────────────────────────────────┤
│ onboarding_page.dart                                │
│   └─ _handleGoogleSignIn() → calls AuthApi          │
│ google_complete_profile_page.dart                    │
│   └─ _completeRegistration() → calls AuthApi        │
├─────────────────────────────────────────────────────┤
│         Data Layer                                  │
├─────────────────────────────────────────────────────┤
│ auth_api.dart                                       │
│   ├─ signInWithGoogle()                             │
│   │  ├─ GoogleSignIn.signIn()                       │
│   │  └─ SupabaseAuth.signInWithIdToken()            │
│   ├─ completeGoogleRegistration()                   │
│   │  ├─ Check username duplicate                    │
│   │  └─ Insert to users table                       │
│   └─ signOutGoogle()                                │
├─────────────────────────────────────────────────────┤
│         External Services                           │
├─────────────────────────────────────────────────────┤
│ SupabaseService                                     │
│   ├─ Supabase Auth (Google OAuth)                   │
│   └─ Supabase Database (PostgreSQL)                 │
│ GoogleSignIn                                        │
│   └─ Google OAuth 2.0 Provider                      │
└─────────────────────────────────────────────────────┘
```

---

## 📱 Page/Route Structure

```
Navigation Tree:

Home (/)
├─ Onboarding (/onboarding)
│  ├─ Page 1: Logo + Tagline
│  ├─ Page 2: Online Shopping
│  └─ Page 3: Sign In Options ← [Google button here]
│     └─ [Tap "Sign in with google"]
│        └─ Google Auth Popup
│           └─ Google Complete Profile (/google-complete-profile) ✨ NEW
│              └─ Form with Email, Username, Phone
│                 └─ [Complete Profile]
│                    └─ Home (/)
├─ Login (/login)
├─ Register (/register)
├─ Email Verification (/email-verification/:email)
└─ ... (other routes)
```

---

## 🗄️ Database Schema Updates

### Users Table Structure

```sql
CREATE TABLE public.users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  username varchar UNIQUE NOT NULL,        -- ← Required for Google login
  email varchar,                           -- ← From Google
  phone varchar,                           -- ← User fills after Google auth
  bio varchar,                             -- ← Optional
  avatarUrl varchar,                       -- ← Optional
  created_at timestamp without time zone   -- ← Auto filled
);
```

### Key Constraints for Google Login:
- `username` must be UNIQUE (check di code before insert)
- `email` nullable (Google provide it)
- `phone` nullable (user fill it)
- `id` generated automatically (Supabase Auth)

---

## 🔑 Environment Variables

```env
# .env file (add to .gitignore)

# Supabase
SUPABASE_URL=https://xxxx.supabase.co
SUPABASE_ANON_KEY=xxxx

# Google OAuth
GOOGLE_WEB_CLIENT_ID=xxxx.apps.googleusercontent.com

# Android
GOOGLE_ANDROID_CLIENT_ID=xxxx.apps.googleusercontent.com

# iOS
GOOGLE_IOS_CLIENT_ID=xxxx.apps.googleusercontent.com
```

---

## 📊 State Management

```
When user taps "Sign in with google":

1. _handleGoogleSignIn() starts
   ├─ setState(() { _isGoogleLoading = true })
   └─ Show loading indicator on button

2. signInWithGoogle() called
   ├─ GoogleSignIn.signIn() → Google popup
   ├─ Wait for user authentication
   └─ Return email

3. If success:
   ├─ Navigate to /google-complete-profile with email
   └─ setState(() { _isGoogleLoading = false })

4. If error:
   ├─ setState(() { _isGoogleLoading = false })
   └─ Show SnackBar error

In google_complete_profile_page:

1. Form initialization
   ├─ Email: initialValue = widget.email (pre-filled)
   ├─ Username: empty
   └─ Phone: empty

2. User fill form

3. Tap "Complete Profile"
   ├─ setState(() { _isLoading = true })
   ├─ Validate form
   ├─ completeGoogleRegistration() called
   ├─ Check username unique
   ├─ Insert to database
   ├─ If success: Navigate to /home
   └─ If error: Show SnackBar + allow retry
```

---

## 🔐 Authentication Flow Detailed

```
GOOGLE AUTH:
┌─────────────────────────────────────┐
│ User in app                         │
├─────────────────────────────────────┤
│ App opens Google Sign-In popup      │
├─────────────────────────────────────┤
│ User logs in with Google            │
├─────────────────────────────────────┤
│ Google returns:                     │
│ - idToken                           │
│ - email                             │
│ - profile info                      │
├─────────────────────────────────────┤
│ App sends idToken to Supabase       │
├─────────────────────────────────────┤
│ Supabase validates token with Google│
├─────────────────────────────────────┤
│ Supabase creates auth session       │
│ (user automatically in Supabase Auth)
├─────────────────────────────────────┤
│ Return email to app                 │
├─────────────────────────────────────┤
│ App navigate to complete profile    │
├─────────────────────────────────────┤
│ User fill username + phone          │
├─────────────────────────────────────┤
│ App insert to users table           │
├─────────────────────────────────────┤
│ App navigate to /home               │
└─────────────────────────────────────┘
```

---

## 📝 File Dependencies

```
google_complete_profile_page.dart
├─ imports:
│  ├─ flutter/material.dart
│  ├─ go_router/go_router.dart
│  ├─ auth_api.dart
│  ├─ auth_repository_impl.dart
│  └─ supabase_service.dart
└─ uses:
   ├─ AuthApi.completeGoogleRegistration()
   ├─ SupabaseService.instance
   └─ GoRouter context.go() & context.pop()

onboarding_page.dart ✏️
├─ imports: (ADDED)
│  ├─ auth_api.dart
│  └─ supabase_service.dart
└─ uses: (ADDED)
   └─ AuthApi.signInWithGoogle()

auth_api.dart ✏️
├─ imports: (ADDED)
│  └─ google_sign_in/google_sign_in.dart
└─ uses:
   ├─ GoogleSignIn
   ├─ SupabaseService
   └─ UserModel

app_router.dart ✏️
├─ imports: (ADDED)
│  └─ google_complete_profile_page.dart
└─ routes: (ADDED)
   └─ /google-complete-profile
```

---

## 🎯 Key Components

### 1. UI Components
- `google_complete_profile_page.dart`: Form page
- `onboarding_page.dart`: Google button

### 2. API Layer
- `auth_api.dart`: Google auth methods
- `supabase_service.dart`: Supabase client

### 3. Navigation
- `app_router.dart`: Routes + redirect

### 4. External Services
- `GoogleSignIn`: OAuth provider
- `Supabase Auth`: Session management
- `PostgreSQL`: Data storage

---

## ✅ Implementation Checklist by Component

### ✅ Code Implementation
- [x] Dependencies added
- [x] New page created
- [x] Auth methods implemented
- [x] UI updated
- [x] Routes configured
- [x] Error handling added
- [x] Form validation added
- [x] Loading states added

### ⏳ Setup Tasks (You need to do)
- [ ] Get Google OAuth credentials
- [ ] Update Android build files
- [ ] Update iOS Info.plist
- [ ] Add GoogleService-Info.plist (iOS)
- [ ] Configure environment variables
- [ ] Test on Android
- [ ] Test on iOS

### ⏳ Deployment Tasks
- [ ] Code review
- [ ] Final testing
- [ ] Commit & push
- [ ] Update version
- [ ] Deploy to production

---

## 🚀 Ready to Start?

1. Check files modified/created ✅
2. Read [IMPLEMENTATION_COMPLETE.md](IMPLEMENTATION_COMPLETE.md) ← START HERE
3. Follow [GOOGLE_SIGNIN_QUICKSTART.md](GOOGLE_SIGNIN_QUICKSTART.md)
4. Use [GOOGLE_SIGNIN_CHECKLIST.md](GOOGLE_SIGNIN_CHECKLIST.md) for setup

---

**All code is ready! Just need to setup credentials and test.** 🎉
