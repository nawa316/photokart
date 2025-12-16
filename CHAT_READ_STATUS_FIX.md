# Perbaikan Sistem Chat - Read Status

## Masalah yang Ditemukan

Pada screenshot yang diberikan, terdapat badge angka "1" di conversation "vanyapatiaa" padahal user adalah yang terakhir mengirim pesan. Ini tidak seharusnya terjadi.

### Root Cause
Di file `chat_remote_datasource.dart` baris 77-82, logic `unreadCount` salah:

```dart
// ❌ SEBELUM (SALAH)
final unreadMessages = await supabaseClient
    .from('message')
    .select('id')
    .eq('convoId', convoMap['id'])
    .neq('userId', userId) as List<dynamic>;
```

**Masalahnya:** Kode ini menghitung **SEMUA** pesan yang bukan dari user saat ini, bukan hanya pesan yang belum dibaca.

## Solusi yang Diimplementasikan

### 1. **Menambah Field `isRead` di Message**
   - Field boolean untuk tracking status baca pesan
   - Ditambahkan di:
     - `message.dart` (entity)
     - `message_model.dart` (model)

### 2. **Memperbaiki Logic Unread Count**
```dart
// ✅ SETELAH (BENAR)
final unreadMessages = await supabaseClient
    .from('message')
    .select('id')
    .eq('convoId', convoMap['id'])
    .neq('userId', userId)
    .eq('isRead', false) as List<dynamic>; // ← Tambahan filter ini
```

Sekarang hanya menghitung pesan yang:
- Bukan dari current user DAN
- Belum dibaca (`isRead = false`)

### 3. **Implementasi Mark as Read**
Ketika user membuka chat, otomatis semua pesan dari lawan bicara akan di-mark sebagai sudah dibaca:

```dart
Future<void> markAsRead(String conversationId) async {
  await supabaseClient
      .from('message')
      .update({'isRead': true})
      .eq('convoId', conversationId)
      .neq('userId', userId)
      .eq('isRead', false);
}
```

### 4. **Visual Indicator (Checkmark)**
Pesan yang dikirim sekarang menampilkan status:
- ✓ **Sent** (single checkmark, abu-abu) - Pesan terkirim tapi belum dibaca
- ✓✓ **Read** (double checkmark, hijau) - Pesan sudah dibaca oleh penerima

## Cara Install

### Step 1: Update Database
Jalankan SQL migration di Supabase SQL Editor:

```bash
# Buka file ini dan copy-paste ke Supabase SQL Editor
database_migration_add_isRead.sql
```

### Step 2: Test Aplikasi
1. Buka chat overview
2. Kirim pesan ke user lain
3. **Sebelum perbaikan:** Badge unread count akan muncul meskipun kamu yang mengirim
4. **Setelah perbaikan:** Tidak ada badge karena pesan dari kamu sendiri

5. Ketika lawan bicara membuka chat:
   - Badge hilang di conversation list
   - Checkmark berubah dari ✓ Sent (grey) ke ✓✓ Read (green)

## Files yang Diubah

1. ✅ `lib/features/chat/domain/entities/message.dart` - Tambah field `isRead`
2. ✅ `lib/features/chat/data/models/message_model.dart` - Tambah field `isRead`
3. ✅ `lib/features/chat/data/datasources/chat_remote_datasource.dart` 
   - Perbaiki logic unread count
   - Implementasi markAsRead
   - Tambah isRead default false saat send message
4. ✅ `lib/features/chat/presentation/pages/chat_detail_page.dart`
   - Call markAsRead saat load messages
   - Tambah visual indicator checkmark
5. ✅ `database_migration_add_isRead.sql` - SQL migration untuk Supabase

## Hasil Akhir

### Chat Overview
- ❌ **Dulu:** Badge angka muncul meskipun kamu yang kirim pesan terakhir
- ✅ **Sekarang:** Badge hanya muncul jika ada pesan dari orang lain yang belum dibaca

### Chat Detail
- ✅ Pesan yang kamu kirim menampilkan status:
  - **Sent** (✓ abu-abu) - Terkirim tapi belum dibaca
  - **Read** (✓✓ hijau) - Sudah dibaca oleh penerima

### Automatic Mark as Read
- ✅ Saat user membuka chat, semua pesan dari lawan bicara otomatis di-mark sebagai sudah dibaca
- ✅ Badge di chat overview akan hilang setelah membuka chat

## Catatan Penting

⚠️ **WAJIB jalankan SQL migration** di Supabase sebelum menjalankan aplikasi, jika tidak akan error karena kolom `isRead` belum ada di database.

## Future Improvements (Opsional)

1. **Real-time updates**: Menggunakan Supabase Realtime untuk update read status secara real-time
2. **Typing indicator**: Menampilkan "typing..." ketika lawan bicara sedang mengetik
3. **Online status**: Menampilkan status online/offline user
4. **Delivered status**: Menambah status "Delivered" sebelum "Read"
