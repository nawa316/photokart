# Google Sign-In Testing Guide

## Pre-Testing Checklist

- [ ] Sudah run `flutter pub get` (untuk update dependencies)
- [ ] Google Sign-In credentials sudah setup
- [ ] Android build.gradle sudah updated
- [ ] iOS Info.plist sudah updated
- [ ] Database migration sudah run (jika ada missing columns)

---

## Testing Steps

### 1. Test di Android Device/Emulator

```bash
# Clean dan get dependencies
flutter clean
flutter pub get

# Run di Android
flutter run -d android
```

**Test Flow:**
1. App buka di Onboarding page
2. Swipe/tap Next sampai ke Page 3 (Sign in options)
3. Tap "Sign in with google"
   - ✅ Loading indicator muncul
   - ✅ Google popup muncul
   - ✅ Pilih Google account
4. Setelah google auth:
   - ✅ Popup dismiss
   - ✅ Navigate ke "Complete Your Profile" page
   - ✅ Email field punya value dari Google
5. Isi form:
   - Username: `testuser123` (min 3 chars)
   - Phone: `081234567890` (min 10 digits)
6. Tap "Complete Profile"
   - ✅ Loading indicator muncul
   - ✅ Validation run
   - ✅ Data simpan ke Supabase
   - ✅ Navigate ke home page
7. Di home page:
   - ✅ User sudah logged in
   - ✅ Profile menunjukkan data yang baru

---

### 2. Test di iOS Device/Simulator

```bash
flutter run -d ios
```

**Same testing steps seperti di atas.**

---

## Error Test Cases

### Test Case 1: Username Already Exists

**Setup:**
- Username yang dipilih sudah exist di database

**Expected:**
- Error message: "Username already taken!"
- Form tidak submit
- User bisa retry dengan username berbeda

### Test Case 2: Invalid Phone Number

**Setup:**
- Isi phone dengan kurang dari 10 digit

**Expected:**
- Error message: "Phone number must be at least 10 digits"
- Form tidak submit

### Test Case 3: Invalid Username

**Setup:**
- Isi username dengan kurang dari 3 character

**Expected:**
- Error message: "Username must be at least 3 characters"
- Form tidak submit

### Test Case 4: Cancel Google Sign-In

**Setup:**
- Tap "Sign in with google"
- Di Google popup, tap back/cancel

**Expected:**
- Popup dismiss
- Stay di onboarding page
- SnackBar error: "Google sign in cancelled"

### Test Case 5: Network Error

**Setup:**
- Turn off internet saat Google auth

**Expected:**
- SnackBar error dengan pesan network error
- User bisa retry

---

## Debug Tips

### Check Supabase Data

```sql
-- Cek data user yang baru dibuat
SELECT id, username, email, phone, created_at 
FROM public.users 
ORDER BY created_at DESC 
LIMIT 5;

-- Cek username unique constraint
SELECT username, COUNT(*) 
FROM public.users 
GROUP BY username 
HAVING COUNT(*) > 1;
```

### Enable Verbose Logging

```bash
flutter run -v
```

### Check Google OAuth Flow

Lihat di console:
- Google auth request
- Token exchange ke Supabase
- User creation di database

---

## Common Issues & Solutions

### Issue 1: "Google sign in cancelled"
**Cause**: User close Google popup
**Solution**: User bisa tap button lagi untuk retry

### Issue 2: "Username already taken!"
**Cause**: Username pilihan sudah exist
**Solution**: User harus pilih username lain

### Issue 3: "Invalid Client" error
**Cause**: Google OAuth credentials tidak correct
**Solution**: Verify credentials di Google Cloud Console

### Issue 4: App crash saat tap Google button
**Cause**: Dependencies tidak ter-install dengan benar
**Solution**: `flutter clean && flutter pub get`

### Issue 5: "User not authenticated" di complete profile
**Cause**: Session expired saat proses
**Solution**: Rare case, user bisa retry dari awal

---

## After Testing

Jika semua test passed ✅:

1. **Commit ke git**:
   ```bash
   git add .
   git commit -m "feat: add Google Sign-In authentication"
   ```

2. **Push ke repository**:
   ```bash
   git push origin main
   ```

3. **Update documentation**:
   - Update README.md dengan feature baru
   - Share GOOGLE_SIGNIN_IMPLEMENTATION.md dengan team

4. **Monitor in production**:
   - Check error logs
   - Monitor user registration via Google
   - Check database untuk duplicate usernames

---

## Performance Metrics

Measure ini optional tapi recommended:

- **Google popup response time**: Harus < 2 seconds
- **Database insert time**: Harus < 1 second
- **Navigation time**: Harus < 500ms

Jika lebih lambat:
- Check internet connection
- Check Supabase performance
- Check device specs

---

## Success Criteria

✅ All test cases passed
✅ No crashes atau errors
✅ User data tersimpan correct di database
✅ Navigation flow lancar
✅ Error handling proper
✅ Form validation works

---

**Happy Testing! 🎉**
