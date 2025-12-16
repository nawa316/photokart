# Google Sign-In Setup untuk PhotoKart

Setelah menambahkan Google Sign-In, Anda perlu melakukan setup di Android dan iOS.

## 1. SETUP ANDROID

### Step 1: Generate SHA-1 fingerprint

Buka terminal di folder project dan jalankan:

```bash
cd android
./gradlew signingReport
```

Catat **SHA1** dari output (untuk debug build).

### Step 2: Setup Firebase Console

1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Create project baru atau gunakan project yang sudah ada
3. Di Firebase Console:
   - Settings → Project Settings
   - Tab "Service Accounts"
   - Click "Generate New Private Key"
4. Di Firebase Console Authentication:
   - Enable "Google" di Sign-in method
   - Masukkan Web Client ID

### Step 3: Update android/build.gradle.kts

Pastikan sudah ada:

```kotlin
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
```

### Step 4: Update android/app/build.gradle.kts

Tambahkan di akhir file:

```kotlin
apply plugin: 'com.google.gms.google-services'

dependencies {
    implementation 'com.google.android.gms:play-services-auth:21.0.0'
}
```

---

## 2. SETUP iOS

### Step 1: Update iOS/Podfile

Pastikan tidak ada pods yang conflict. Update Podfile jika perlu.

### Step 2: Update Info.plist

Buka `ios/Runner/Info.plist` dan tambahkan:

```xml
<dict>
    ...
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
    ...
</dict>
```

Ganti `YOUR_IOS_CLIENT_ID` dengan Client ID dari Google Cloud Console.

### Step 3: Update GoogleService-Info.plist

1. Download GoogleService-Info.plist dari Firebase Console
2. Copy ke `ios/Runner/` folder
3. Di Xcode, right-click `ios/Runner` → Add Files to Runner → GoogleService-Info.plist

---

## 3. UPDATE ENV FILE

Buat atau update `.env` file di root project:

```
GOOGLE_WEB_CLIENT_ID=YOUR_WEB_CLIENT_ID.apps.googleusercontent.com
SUPABASE_URL=YOUR_SUPABASE_URL
SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
```

---

## 4. TESTING

### Test Android:

```bash
flutter run -d android
```

Tap "Sign in with google" button dan test flow-nya.

### Test iOS:

```bash
flutter run -d ios
```

---

## 5. TROUBLESHOOTING

### Error: "12: SignInException"
- Periksa SHA-1 fingerprint apakah sudah correct di Firebase

### Error: "INVALID_CLIENT"
- Periksa OAuth Client ID apakah valid di Google Cloud Console

### Error di iOS: "com.google.gid.GoogleSignInError error 0"
- Pastikan Info.plist sudah benar
- Pastikan GoogleService-Info.plist sudah di-add ke Xcode

---

## IMPORTANT: Database Migration

Pastikan tabel `users` di Supabase sudah punya column:
- `username` (varchar, unique)
- `email` (varchar)
- `phone` (varchar)
- `bio` (varchar, nullable)
- `avatarUrl` (varchar, nullable)
- `created_at` (timestamp)

Jika belum, jalankan migration:

```sql
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS username varchar UNIQUE NOT NULL;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS email varchar;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS phone varchar;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS bio varchar;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS avatarUrl varchar;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS created_at timestamp without time zone;
```

---

Setelah setup selesai, flow Google Sign-In akan bekerja:
1. User tap "Sign in with google"
2. Google popup muncul
3. Setelah auth, user dialihkan ke halaman "Complete Profile"
4. User isi username + phone (email sudah pre-filled)
5. User tap "Complete Profile"
6. User berhasil login dan diarahkan ke home page
